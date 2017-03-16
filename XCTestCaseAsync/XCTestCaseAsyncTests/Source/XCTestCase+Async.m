//
//  XCTestCase+Async.m
//  Mask
//
//  Created by bomo on 2017/3/15.
//  Copyright © 2017年 bomo. All rights reserved.
//

#import "XCTestCase+Async.h"

@implementation XCTestCase (Async)

- (void)setUp
{
    self.continueAfterFailure = false;
}

- (void)waitWithAsync:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block
{
    [self waitWithTimeout:INFINITY asyncBlock:block];
}

- (BOOL)waitWithTimeout:(NSTimeInterval)timeout asyncBlock:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block
{
    __block BOOL isFinished = NO;
    
    FinishBlock finishBlock = ^{
        isFinished = YES;
    };
    
    BOOL isTimeOut = NO;
    NSDate *startDate = [NSDate date];
    //execute async block
    block(finishBlock);
    
    //wait with runloop
    do {
        [NSRunLoop.mainRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        
        //check whethere is timeout
        isTimeOut = [[NSDate date] timeIntervalSinceDate:startDate] > timeout;
    } while (!isFinished && !isTimeOut);
    
    return !isTimeOut;
}

- (BOOL)waitWithRetryTimes:(NSInteger)retryTimes asyncBlock:(void (^ _Nonnull)(CompleteBlock _Nonnull complete))block
{
    NSInteger retryTime = 0;
    
    while (retryTime++ < retryTimes) {
        __block BOOL isFinished = NO;
        __block BOOL retry = NO;
        
        CompleteBlock completeBlock = ^(BOOL finished){
            if (finished) {
                isFinished = YES;
            } else {
                retry = YES;
            }
        };
        
        block(completeBlock);
        
        do {
            [NSRunLoop.mainRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        } while (!isFinished && !retry);
        
        if (isFinished) {
            return YES;
        }
    }
    return NO;
}

@end
