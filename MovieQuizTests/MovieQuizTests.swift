//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Pavel Strezh on 14.08.2026.
//

//import Testing
//
//struct MovieQuizTests {
//
//    @Test func example() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//        // Swift Testing Documentation
//        // https://developer.apple.com/documentation/testing
//    }
//
//}
//
//
//import XCTest
//
//struct ArithmeticOperations {
//    func additions (num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            handler(num1 + num2)
//        }
//    }
//    
//    func subtraction (num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            handler(num1 - num2)
//        }
//    }
//    
//    func multiplication (num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            handler(num1 * num2)
//        }
//    }
//}
//
//class MovieQuizTests: XCTestCase {
//    func testAdditions() throws {
//        //Given
//        let arithmeticOperations = ArithmeticOperations()
//        let num1 = 1
//        let num2 = 2
//        
//        // When
//        //let expectation = expectation(description: "Addition function expectation")
//        let expectation = expectation(description: "Addition function expectation")
//
//        
//        arithmeticOperations.additions(num1: num1, num2: num2) { result in
//            // Then
//            XCTAssertEqual(result, 3)
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 2)
//    }
//}
