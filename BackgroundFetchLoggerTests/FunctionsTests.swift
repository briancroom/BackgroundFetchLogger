//
//  FunctionsTests.swift
//  BackgroundFetchLogger
//
//  Created by DEVFLOATER106-XL on 2015-02-06.
//  Copyright (c) 2015 Pivotal Labs. All rights reserved.
//

import UIKit
import XCTest
import BackgroundFetchLogger

class FunctionsTests: XCTestCase {

    func testCalculatesDeltasFromIntervals() {
        let intervals: [NSTimeInterval] = [0, 10, 40, 100]
        XCTAssertEqual(deltas(intervals), [10, 30, 60])
    }
}
