//
//  ClearAllTests.swift
//  StubTests
//
//  Created by tokijh on 2022/04/18.
//  Copyright © 2022 tokijh. All rights reserved.
//

import XCTest
import Stub

final class ClearAllTests: XCTestCase {

  override func setUp() {
    super.setUp()
    Stub.clearAll()
  }

  func test_ClearAll() {
    // given
    let fetchServices = (0..<10).map { _ in FetchServiceStub() }
    let saveServices = (0..<10).map { _ in SaveServiceStub() }

    // Register and invoke to make executions and a stubbing function
    fetchServices.forEach { fetchService in
      fetchService.fetchNumberStub.register { completion in
        completion(0)
      }
      fetchService.fetchNumber { _ in }
    }
    saveServices.forEach { saveService in
      saveService.saveNumberStub.register { _ in }
      saveService.saveNumber(number: 0)
    }

    let fetchNumberStubs = fetchServices.map(\.fetchNumberStub)
    let saveNumberStubs = saveServices.map(\.saveNumberStub)

    let fetchNumberExecutionsBeforeClearAll = fetchNumberStubs.flatMap { $0.executions() }
    let saveNumberExecutionsBeforeClearAll = saveNumberStubs.flatMap { $0.executions() }
    XCTAssertEqual(fetchNumberExecutionsBeforeClearAll.count, 10)
    XCTAssertEqual(saveNumberExecutionsBeforeClearAll.count, 10)
    fetchNumberStubs.forEach { stub in
      XCTAssertTrue(stub.isStubbing)
    }
    saveNumberStubs.forEach { stub in
      XCTAssertTrue(stub.isStubbing)
    }

    // when
    Stub.clearAll()

    // then
    let fetchNumberExecutionsAfterClearAll = fetchNumberStubs.flatMap { $0.executions() }
    let saveNumberExecutionsAfterClearAll = saveNumberStubs.flatMap { $0.executions() }
    XCTAssertEqual(fetchNumberExecutionsAfterClearAll.count, 0)
    XCTAssertEqual(saveNumberExecutionsAfterClearAll.count, 0)
    fetchNumberStubs.forEach { stub in
      XCTAssertFalse(stub.isStubbing)
    }
    saveNumberStubs.forEach { stub in
      XCTAssertFalse(stub.isStubbing)
    }
  }
}

private final class FetchServiceStub {
  @StubProxy(fetchNumber) var fetchNumberStub
  func fetchNumber(_ completion: @escaping (Int) -> Void) {
    fetchNumberStub.invoke(completion)
  }
}

private final class SaveServiceStub {
  @StubProxy(saveNumber) var saveNumberStub
  func saveNumber(number: Int) {
    saveNumberStub.invoke(number)
  }
}
