//
//  XCTestCase+Async.h
//  Mask
//
//  Created by bomo on 2017/3/15.
//  Copyright © 2017年 bomo. All rights reserved.
//

#import <XCTest/XCTest.h>
typedef void(^FinishBlock)();
typedef void(^CompleteBlock)(BOOL finished);

/** asycn support for XCTestCase */
@interface XCTestCase (Async)

/** 
 waiting for an async block, you must call complete() when async block finished
 @param block asyncblock (you must call complete() when finish)
 */
- (void)waitWithAsync:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block;

/**
 waiting for an async block, you must call complete() when async block finished
 @param block asyncblock (you must call complete() when finish)
 @return YES: finish, NO: timeout
 */
- (BOOL)waitWithTimeout:(NSTimeInterval)timeout asyncBlock:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block;


/** 
 waiting for an async block, you must call complete() when async block finished
 @param retryTimes asyncblock (you must call complete() when finish)
 @param block asyncblock (you must call complete(YES) when finish, or call complete(NO) when need retry)
 @return YES: finish, NO: no finished after retry
 */
- (BOOL)waitWithRetryTimes:(NSInteger)retryTimes asyncBlock:(void (^ _Nonnull)(CompleteBlock _Nonnull complete))block;

@end