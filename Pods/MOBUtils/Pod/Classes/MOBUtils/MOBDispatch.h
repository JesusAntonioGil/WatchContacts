//
//  MOBDispatch.h
//  utils
//
//  Created by Alex Ruperez on 03/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#ifndef utils_MOBDispatch_h
#define utils_MOBDispatch_h

#import <Foundation/Foundation.h>

__unused static void mob_dispatch_main(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

__unused static void mob_dispatch_after_seconds(NSTimeInterval delayInSeconds, dispatch_block_t block)
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

__unused static void mob_dispatch_background(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

#endif
