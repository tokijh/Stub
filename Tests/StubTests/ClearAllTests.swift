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

  #if swift(>=5.6) && canImport(_Concurrency)

  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  func test_ClearAllWithAsyncStub() async {
    // given
    let fetchServices = (0..<10).map { _ in FetchServiceStub() }
    let saveServices = (0..<10).map { _ in SaveServiceStub() }
    let asyncFetchServices = (0..<10).map { _ in AsyncFetchServiceStub() }
    let asyncSaveServices = (0..<10).map { _ in AsyncSaveServiceStub() }

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
    asyncFetchServices.forEach { asyncFetchService in
      Task {
        await asyncFetchService.fetchNumberStub.register { completion in
          completion(0)
        }
        await asyncFetchService.fetchNumber { _ in }
      }
    }
    asyncSaveServices.forEach { asyncSaveService in
      Task {
        await asyncSaveService.saveNumberStub.register { _ in }
        await asyncSaveService.saveNumber(number: 0)
      }
    }

    let fetchNumberStubs = fetchServices.map(\.fetchNumberStub)
    let saveNumberStubs = saveServices.map(\.saveNumberStub)
    let asyncFetchNumberStubs = asyncFetchServices.map(\.fetchNumberStub)
    let asyncSaveNumberStubs = asyncSaveServices.map(\.saveNumberStub)

    let fetchNumberExecutionsBeforeClearAll = fetchNumberStubs.flatMap { $0.executions() }
    let saveNumberExecutionsBeforeClearAll = saveNumberStubs.flatMap { $0.executions() }
    let asyncFetchNumberExecutionsBeforeClearAll = asyncFetchNumberStubs.map { stub in
      Task { await stub.executions() }
    }
    let asyncSaveNumberExecutionsBeforeClearAll = asyncSaveNumberStubs.map { stub in
      Task { await stub.executions() }
    }
    XCTAssertEqual(fetchNumberExecutionsBeforeClearAll.count, 10)
    XCTAssertEqual(saveNumberExecutionsBeforeClearAll.count, 10)
    XCTAssertEqual(asyncFetchNumberExecutionsBeforeClearAll.count, 10)
    XCTAssertEqual(asyncSaveNumberExecutionsBeforeClearAll.count, 10)
    fetchNumberStubs.forEach { stub in
      XCTAssertTrue(stub.isStubbing)
    }
    saveNumberStubs.forEach { stub in
      XCTAssertTrue(stub.isStubbing)
    }
    asyncFetchNumberStubs.forEach { stub in
      XCTAssertTrue(stub.isStubbing)
    }
    asyncSaveNumberStubs.forEach { stub in
      XCTAssertTrue(stub.isStubbing)
    }

    // when
    Stub.clearAll()

    // then
    let fetchNumberExecutionsAfterClearAll = fetchNumberStubs.flatMap { $0.executions() }
    let saveNumberExecutionsAfterClearAll = saveNumberStubs.flatMap { $0.executions() }
    let asyncFetchNumberExecutionCountAfterClearAll: Int = await {
      var count = 0
      for stub in asyncFetchNumberStubs {
        count += await stub.executions().count
      }
      return count
    }()
    let asyncSaveNumberExecutionCountAfterClearAll: Int = await {
      var count = 0
      for stub in asyncSaveNumberStubs {
        count += await stub.executions().count
      }
      return count
    }()
    XCTAssertEqual(fetchNumberExecutionsAfterClearAll.count, 0)
    XCTAssertEqual(saveNumberExecutionsAfterClearAll.count, 0)
    XCTAssertEqual(asyncFetchNumberExecutionCountAfterClearAll, 0)
    XCTAssertEqual(asyncSaveNumberExecutionCountAfterClearAll, 0)
    fetchNumberStubs.forEach { stub in
      XCTAssertFalse(stub.isStubbing)
    }
    saveNumberStubs.forEach { stub in
      XCTAssertFalse(stub.isStubbing)
    }
    asyncFetchNumberStubs.forEach { stub in
      XCTAssertFalse(stub.isStubbing)
    }
    asyncSaveNumberStubs.forEach { stub in
      XCTAssertFalse(stub.isStubbing)
    }
  }

  #endif
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

#if swift(>=5.6) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
private final class AsyncFetchServiceStub {
  @AsyncStubProxy(fetchNumber) var fetchNumberStub
  func fetchNumber(_ completion: @escaping (Int) -> Void) async {
    await fetchNumberStub.invoke(completion)
  }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
private final class AsyncSaveServiceStub {
  @AsyncStubProxy(saveNumber) var saveNumberStub
  func saveNumber(number: Int) async {
    await saveNumberStub.invoke(number)
  }
}

#endif
