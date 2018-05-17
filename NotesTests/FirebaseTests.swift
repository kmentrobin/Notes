//
//  FirebaseTests.swift
//  NotesTests
//
//  Created by Robin Kment on 17.05.18.
//  Copyright © 2018 cz.robinkment. All rights reserved.
//

import XCTest
@testable import Notes

class FirebaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        let sc = FirebaseService.shared
        
        let expect = self.expectation(description: "exp")
        sc.login { (success) in
            XCTAssertTrue(success)
            expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) in
            guard error == nil else {
                XCTAssert(false)
                NSLog("Timeout Error.")
                return
            }
        }
    }
    
}
