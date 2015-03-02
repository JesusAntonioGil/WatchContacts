//
//  MOBConsole.m
//  MOBConsole
//
//  Created by Alejandro Rupérez on 12/03/14.
//  Copyright (c) 2014 Alejandro Rupérez. All rights reserved.
//

#import "MOBConsole.h"

#import "NSBundle+MOBExtension.h"


@interface MOBConsole()
<UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UITextView *consoleView;
@property (strong, nonatomic) UITextField *inputField;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) NSMutableArray *log;
@property (assign, nonatomic) BOOL animating;
@property (strong, nonatomic) NSDateFormatter *logDateFormatter;
@property (strong, nonatomic) NSDateFormatter *fileDateFormatter;

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end


@implementation MOBConsole

+ (MOBConsole *)sharedConsole
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)load
{
    [MOBConsole performSelectorOnMainThread:@selector(sharedConsole) withObject:nil waitUntilDone:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
#ifdef DEBUG
        _enabled = YES;
#else
        _enabled = NO;
#endif
        _animating = NO;
        _logLevel = MOBConsoleLogLevelInfo;
        _saveLogToUserDefaults = NO;
        _saveLogToFile = NO;
        _maxLogItems = 1000;
        _delegate = nil;
        
        _defaultSimulatorTouchesToShow = 2;
        _defaultDeviceTouchesToShow = 3;
        
        self.infoString = [NSString stringWithFormat:@"%@ Console", [NSBundle productName]];
        self.inputPlaceholderString = @"Enter command...";
        self.logSubmissionEmail = nil;
        
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor greenColor];
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.logDateFormatter = [[NSDateFormatter alloc] init];
        [self.logDateFormatter setDateFormat:@"<HH:mm:ss:SSS>"];
        self.fileDateFormatter = [[NSDateFormatter alloc] init];
        [self.fileDateFormatter setDateFormat:@"dd_MM_yy"];
        
        self.log = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MOBConsoleLog"]];
        
        if (&UIApplicationDidEnterBackgroundNotification != NULL)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSettings) name:UIApplicationDidEnterBackgroundNotification object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSettings) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateView:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeView:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        [_longPressGestureRecognizer setNumberOfTouchesRequired:TARGET_IPHONE_SIMULATOR ? _defaultSimulatorTouchesToShow: _defaultDeviceTouchesToShow];
        [[self mainWindow] addGestureRecognizer:_longPressGestureRecognizer];
        
	}
	return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
	self.view.backgroundColor = _backgroundColor;
	self.view.autoresizesSubviews = YES;
    
	_consoleView = [[UITextView alloc] initWithFrame:self.view.bounds];
	_consoleView.font = [UIFont fontWithName:@"Courier" size:12];
	_consoleView.textColor = _textColor;
	_consoleView.backgroundColor = [UIColor clearColor];
    _consoleView.indicatorStyle = _indicatorStyle;
	_consoleView.editable = NO;
	_consoleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self setConsoleText];
	[self.view addSubview:_consoleView];
    
	self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton setTitle:@"⚙" forState:UIControlStateNormal];
    [_actionButton setTitleColor:_textColor forState:UIControlStateNormal];
    [_actionButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    _actionButton.titleLabel.font = [_actionButton.titleLabel.font fontWithSize:28];
	_actionButton.frame = CGRectMake(self.view.frame.size.width - 29, self.view.frame.size.height - 33, 28, 28);
	[_actionButton addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
	_actionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[self.view addSubview:_actionButton];
    
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(8, self.view.frame.size.height - 33, self.view.frame.size.width - 40, 28)];
    _inputField.borderStyle = UITextBorderStyleRoundedRect;
    _inputField.font = [UIFont fontWithName:@"Courier" size:12];
    _inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputField.returnKeyType = UIReturnKeyDone;
    _inputField.enablesReturnKeyAutomatically = NO;
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputField.placeholder = _inputPlaceholderString;
    _inputField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _inputField.delegate = self;
    CGRect frame = self.view.bounds;
    frame.size.height -= 38;
    _consoleView.frame = frame;
    [self.view addSubview:_inputField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
	[self.consoleView scrollRangeToVisible:NSMakeRange(self.consoleView.text.length, 0)];
}

#pragma mark - Accessors

- (void)setDefaultSimulatorTouchesToShow:(NSUInteger)defaultSimulatorTouchesToShow
{
    _defaultSimulatorTouchesToShow = defaultSimulatorTouchesToShow;
    
    [self.longPressGestureRecognizer setNumberOfTouchesRequired:defaultSimulatorTouchesToShow];
}

- (void)setDefaultDeviceTouchesToShow:(NSUInteger)defaultDeviceTouchesToShow
{
    _defaultDeviceTouchesToShow = defaultDeviceTouchesToShow;
    
    [self.longPressGestureRecognizer setNumberOfTouchesRequired:defaultDeviceTouchesToShow];
}

#pragma mark - Public

+ (void)logMessage:(NSString *)message
{
    if ([[self sharedConsole] saveLogToFile])
    {
        [self logToFile:@"MOBConsoleLog" message:message];
    }
    
    if ([self sharedConsole].enabled)
    {
        [self logMessageOnMainThread:message];
    }
}

+ (void)log:(NSString *)format arguments:(va_list)argList
{
    if ([[MOBConsole sharedConsole] saveLogToFile])
    {
        [self logToFile:@"MOBConsoleLog" format:format arguments:argList];
    }
    
    if ([self sharedConsole].enabled)
    {
        NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
        [self logMessageOnMainThread:message];
    }
}

+ (void)log:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= MOBConsoleLogLevelNone)
    {
        va_list argList;
        va_start(argList, format);
        [self log:format arguments:argList];
        va_end(argList);
    }
}

+ (void)logMessageOnMainThread:(NSString *)message
{
    if ([NSThread currentThread] == [NSThread mainThread])
    {
        [[self sharedConsole] logOnMainThread:message];
    }
    else
    {
        [[self sharedConsole] performSelectorOnMainThread:@selector(logOnMainThread:) withObject:message waitUntilDone:NO];
    }
}

+ (void)info:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= MOBConsoleLogLevelInfo)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"INFO: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)warn:(NSString *)format, ...
{
	if ([self sharedConsole].logLevel >= MOBConsoleLogLevelWarning)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"WARNING: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)error:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= MOBConsoleLogLevelError)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"ERROR: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)crash:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= MOBConsoleLogLevelCrash)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"CRASH: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)logToFile:(NSString *)fileName format:(NSString *)format arguments:(va_list)argList
{
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    
    [self logToFile:fileName message:message];
}

+ (void)logToFile:(NSString *)fileName message:(NSString *)message
{
    message = [NSString stringWithFormat:@"%@ - %@\n", [[self sharedConsole].logDateFormatter stringFromDate:[NSDate date]], message];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dateString = [[self sharedConsole].fileDateFormatter stringFromDate:[NSDate date]];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.txt", fileName, dateString, nil]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];
    }
    
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)logToFile:(NSString *)fileName log:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    [self logToFile:fileName format:format arguments:argList];
    va_end(argList);
}

+ (void)clear
{
	[[MOBConsole sharedConsole] resetLog];
}

+ (void)show
{
	[[MOBConsole sharedConsole] showConsole];
}

+ (void)hide
{
	[[MOBConsole sharedConsole] hideConsole];
}

#pragma mark - Private

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

- (void)setConsoleText
{
	NSString *text = _infoString;
	long touches = (TARGET_IPHONE_SIMULATOR ? _defaultSimulatorTouchesToShow: _defaultDeviceTouchesToShow);
	if (touches > 0 && touches < 11)
	{
		text = [text stringByAppendingFormat:@"\nPress with %li finger%@ to hide console", touches, (touches != 1)? @"s": @""];
	}
	text = [text stringByAppendingString:@"\n--------------------------------------\n"];
	text = [text stringByAppendingString:[[_log arrayByAddingObject:@">"] componentsJoinedByString:@"\n"]];
	_consoleView.text = text;

	[_consoleView scrollRangeToVisible:NSMakeRange(_consoleView.text.length, 0)];
}

- (void)resetLog
{
	self.log = [NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setObject:_log forKey:@"MOBConsoleLog"];
	[self setConsoleText];
}

- (void)saveSettings
{
    if (_saveLogToUserDefaults)
    {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)findAndResignFirstResponder:(UIView *)view
{
    if ([view isFirstResponder])
	{
        [view resignFirstResponder];
        return YES;
    }
    for (UIView *subview in view.subviews)
	{
        if ([self findAndResignFirstResponder:subview])
        {
			return YES;
		}
    }
    return NO;
}

- (void)infoAction
{
	[self findAndResignFirstResponder:[self mainWindow]];

	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear Log" otherButtonTitles:@"Send by Email", @"Close", nil];

	sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[sheet showInView:self.view];
}

- (CGAffineTransform)viewTransform
{
	CGFloat angle = 0;
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
            angle = 0;
            break;
		case UIInterfaceOrientationPortraitUpsideDown:
			angle = M_PI;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			angle = -M_PI_2;
			break;
		case UIInterfaceOrientationLandscapeRight:
			angle = M_PI_2;
			break;
        default:
            break;
	}
	return CGAffineTransformMakeRotation(angle);
}

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (void)showConsole
{
	if (!_animating && !self.view.superview)
	{
        [self setConsoleText];

        self.view.frame = [self onscreenFrame];
        [self findAndResignFirstResponder:[self mainWindow]];

        CATransition* transition = [CATransition animation];
        transition.type = @"rippleEffect";
        transition.duration = 1.0;

        _animating = YES;

        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            _animating = NO;
        }];
        [[self mainWindow].layer addAnimation:transition forKey:nil];
        [[self mainWindow] addSubview:self.view];
        [CATransaction commit];
	}
}

- (void)hideConsole
{
	if (!_animating && self.view.superview)
	{
        [self findAndResignFirstResponder:[self mainWindow]];

        CATransition* transition = [CATransition animation];
        transition.type = @"rippleEffect";
        transition.duration = 1.0;

        _animating = YES;

        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            _animating = NO;
        }];
        [[self mainWindow].layer addAnimation:transition forKey:nil];
        [self.view removeFromSuperview];
        [CATransaction commit];
	}
}

- (void)rotateView:(NSNotification *)notification
{
	self.view.transform = [self viewTransform];
	self.view.frame = [self onscreenFrame];

	if (_delegate != nil)
	{
		//workaround for autoresizeing glitch
		CGRect frame = self.view.bounds;
		frame.size.height -= 38;
		self.consoleView.frame = frame;
	}
}

- (void)resizeView:(NSNotification *)notification
{
	CGRect frame = [[notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
	CGRect bounds = [UIScreen mainScreen].bounds;
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			bounds.origin.y += frame.size.height;
			bounds.size.height -= frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			bounds.size.height -= frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			bounds.origin.x += frame.size.width;
			bounds.size.width -= frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			bounds.size.width -= frame.size.width;
			break;
        default:
            break;
	}
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.35f];
	self.view.frame = bounds;
	[UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect frame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGFloat duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	UIViewAnimationCurve curve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];

	CGRect bounds = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			bounds.size.height -= frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			bounds.origin.y += frame.size.height;
			bounds.size.height -= frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			bounds.size.width -= frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			bounds.origin.x += frame.size.width;
			bounds.size.width -= frame.size.width;
			break;
        default:
            break;
	}
	self.view.frame = bounds;

	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	CGFloat duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	UIViewAnimationCurve curve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];

	self.view.frame = [self onscreenFrame];

	[UIView commitAnimations];
}

- (void)logOnMainThread:(NSString *)message
{
	[_log addObject:[NSString stringWithFormat:@"> %@ %@", [_logDateFormatter stringFromDate:[NSDate date]], message]];

	if ([_log count] > _maxLogItems)
	{
		[_log removeObjectAtIndex:0];
	}

    [[NSUserDefaults standardUserDefaults] setObject:_log forKey:@"MOBConsoleLog"];

    if (self.view.superview)
    {
        [self setConsoleText];
    }
}

- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer
{
	if (_enabled && !_animating)
	{
        if (!self.view.superview)
        {
            [self showConsole];
        }
        else
        {
            [self hideConsole];
        }
	}
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (![textField.text isEqualToString:@""])
	{
		[MOBConsole log:textField.text];
		[_delegate mobConsoleDidEnterCommand:textField.text];
		textField.text = @"";
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	return YES;
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.destructiveButtonIndex)
	{
		[MOBConsole clear];
	}
	else if (buttonIndex == 1)
	{
        NSString *URLSafeName = [self URLEncodedString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
        NSString *URLSafeLog = [self URLEncodedString:[_log componentsJoinedByString:@"\n"]];
        NSString *URLString = [NSString stringWithFormat:@"mailto:%@?subject=%@%%20Console%%20Log&body=%@",
                                      [_logSubmissionEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ?: @"", URLSafeName, URLSafeLog];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
    else if (buttonIndex == 2)
    {
        [self hideConsole];
    }
}

#pragma mark - Helpers

- (NSString *)URLEncodedString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), kCFStringEncodingUTF8));
}

@end
