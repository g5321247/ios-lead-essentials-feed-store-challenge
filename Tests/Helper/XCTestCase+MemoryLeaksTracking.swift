//
//  XCTestCase+MemoryLeaks.swift
//  Tests
//
//  Created by 劉峻岫 on 2020/12/23.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(sut: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
    }
}
