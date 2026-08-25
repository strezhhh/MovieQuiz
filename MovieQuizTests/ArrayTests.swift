//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Pavel Strezh on 14.08.2026.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let array = [1, 1, 2, 3, 4]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    private func testGetValueOutRange() throws {
        // Given
        let array = [1, 1, 2, 3, 4]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
    
}

