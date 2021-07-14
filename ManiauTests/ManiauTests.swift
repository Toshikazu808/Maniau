//
//  ManiauTests.swift
//  ManiauTests
//
//  Created by Ryan Kanno on 7/14/21.
//

import XCTest
@testable import Maniau

class ManiauTests: XCTestCase {
   
   func testTimeDoubleToString() {
      let num1 = Double(4.5).timeDoubleToString()
      let num2 = Double(13.15).timeDoubleToString()
      let num3 = Double(24).timeDoubleToString()
      let num4 = Double(5.3).timeDoubleToString()
      let num5 = Double(12.59).timeDoubleToString()
      XCTAssertEqual(num1, "4:50 AM")
      XCTAssertEqual(num2, "1:15 PM")
      XCTAssertEqual(num3, "12:00 AM")
      XCTAssertEqual(num4, "5:30 AM")
      XCTAssertEqual(num5, "12:59 PM")
   }
   
   func testTimeStringToDouble() {
      let num1 = String("4:50 AM").timeStringToDouble()
      let num2 = String("1:15 PM").timeStringToDouble()
      let num3 = String("12:00 AM").timeStringToDouble()
      let num4 = String("5:30 AM").timeStringToDouble()
      let num5 = String("12:59 PM").timeStringToDouble()
      XCTAssertEqual(num1, 4.5)
      XCTAssertEqual(num2, 13.15)
      XCTAssertEqual(num3, 24.00)
      XCTAssertEqual(num4, 5.3)
      XCTAssertEqual(num5, 12.59)
   }
   
}
