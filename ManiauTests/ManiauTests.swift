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
   
   func testTimeStringToTimeInterval() {
      let time1 = String("Jul 10, 2021 7:00 AM").toTimeInterval()
      let time2 = String("Aug 24, 2021 3:05 PM").toTimeInterval()
      let time3 = String("Sep 19, 2021 8:00 AM").toTimeInterval()
      let time4 = String("Jun 5, 1992 1:00 PM").toTimeInterval()
      let time5 = String("Dec 25, 2021 12:00 AM").toTimeInterval()
      XCTAssertEqual(time1, 1625925600.0)
      XCTAssertEqual(time2, 1629842700.0)
      XCTAssertEqual(time3, 1632063600.0)
      XCTAssertEqual(time4, 707774400.0)
      XCTAssertEqual(time5, 1640419200.0)
   }
}
