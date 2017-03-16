//
//  XCTestCaseAsyncTests.m
//  XCTestCaseAsyncTests
//
//  Created by bomo on 2017/3/16.
//  Copyright © 2017年 bomo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Async.h"

@interface XCTestCaseAsyncTests : XCTestCase

@end

@implementation XCTestCaseAsyncTests


- (void)setUp
{
    self.continueAfterFailure = NO;
}

- (void)testRetry
{
    __block NSInteger executeTimes = 0;
    
    NSInteger retryTimes = 3;
    
    [self waitWithRetryTimes:retryTimes asyncBlock:^(CompleteBlock  _Nonnull complete) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            executeTimes++;
            
            NSLog(@"failure");
            complete(NO);
            
            //NSLog(@"success");
            //complete(YES);
        });
    }];
    NSLog(@"完成");
    
    XCTAssertEqual(executeTimes, retryTimes, "重试测试");
    
    
    executeTimes = 0;
    retryTimes = 3;
    
    NSInteger totalFailTimes = 2;
    __block NSInteger failTimes = totalFailTimes;
    
    BOOL success = [self waitWithRetryTimes:retryTimes asyncBlock:^(CompleteBlock  _Nonnull complete) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            executeTimes++;
            
            if (failTimes-- > 0) {
                NSLog(@"failure");
                complete(NO);
            } else {
                NSLog(@"success");
                complete(YES);
            }
        });
    }];
    NSLog(@"finish");
    
    XCTAssertTrue(success);
    XCTAssertEqual(executeTimes, totalFailTimes + 1, "重试测试");
}

- (void)testAsync
{
    __block BOOL executeSuccess = NO;

    [self waitWithAsync:^(FinishBlock  _Nonnull complete) {
        // async method
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // async block
            executeSuccess = YES;
            // set finish flag, finish async
            complete();
        });
    }];

    XCTAssertTrue(executeSuccess, @"异步执行测试");
}

- (void)testTimeOut
{
    __block BOOL executeSuccess = NO;
    BOOL success = [self waitWithTimeout:3 asyncBlock:^(FinishBlock  _Nonnull complete) {
        // 异步方法
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            executeSuccess = YES;
            //设置标识，结束异步
            complete();
        });
    }];
    if (success) {
        NSLog(@"block execute success");
    } else {
        NSLog(@"timeout");
    }
    
    XCTAssertFalse(success, @"异步超时");
    XCTAssertFalse(executeSuccess, @"异步超时");
    
}

@end
