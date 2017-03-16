//
//  XCTestCaseAsyncTests.swift
//  XCTestCaseAsync
//
//  Created by bomo on 2017/3/16.
//  Copyright © 2017年 bomo. All rights reserved.
//

class XCTestCaseAsyncTests: XCTestCase {
    override func setUp() {
        self.continueAfterFailure = false;
    }
    
    func testRetry() {
        var executeTimes = 0
        let retryTimes = 3
        var success = self.wait(withRetryTimes: retryTimes) { (complete) in
            let delay = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                executeTimes+=1
                print("failure")
                complete(false);
            })
        }
        XCTAssertEqual(executeTimes, retryTimes, "retry test")
        
        executeTimes = 0
        let totalFailTimes = 2
        var failTimes = totalFailTimes
        
        success = self.wait(withRetryTimes: retryTimes, asyncBlock: { (complete) in
            let delay = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                executeTimes+=1
                
                failTimes-=1
                if failTimes > 0 {
                    print("failure")
                    complete(false);
                } else {
                    print("success")
                    complete(true);
                }
            })
        })
        
        XCTAssertTrue(success)
        XCTAssertEqual(executeTimes, totalFailTimes+1, "retry test")
    }
    
    func testAsync() {
        var executeSuccess = false
        self.wait { (complete) in
            let delay = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                executeSuccess = true
                complete()
            })
        }
        
        XCTAssertTrue(executeSuccess)
    }
    
    func testTimeout() {
        var executeSuccess = false
        let success = self.wait(withTimeout: 3) { (complete) in
            let delay = DispatchTime.now() + .seconds(5)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                executeSuccess = true
                complete()
            })
        }
        if success {
            print("success")
        } else {
            print("timeout")
        }
    }
}

