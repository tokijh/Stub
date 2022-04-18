//
//  StubTests.swift
//  StubTests
//
//  Created by tokijh on 2022/04/18.
//  Copyright © 2022 tokijh. All rights reserved.
//

import XCTest
import Stub

final class StubTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    Stub.clearAll()
  }

  func test_arguments0_defaultNo_returnVoid() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments0_returnVoid_defaultNo_stub

    stub.register { }

    // when
    stubClass.arguments0_returnVoid_defaultNo()

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
  }

  func test_arguments0_defaultVoid_returnVoid() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments0_returnVoid_defaultVoid_stub

    // when
    stubClass.arguments0_returnVoid_defaultVoid()
    stubClass.arguments0_returnVoid_defaultVoid()

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 2)
  }

  func test_arguments1_defaultNo_returnInt() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments1_returnInt_defaultNo_stub

    stub.register { _ in 10 }

    // when
    let result = stubClass.arguments1_returnInt_defaultNo("Hello")

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments, "Hello")
    XCTAssertEqual(executions[0].result, 10)
    XCTAssertEqual(result, 10)
  }

  func test_arguments1_defaultInt_returnInt() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments1_returnInt_defaultInt_stub

    // when
    let result = stubClass.arguments1_returnInt_defaultInt("Hello, default!")

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments, "Hello, default!")
    XCTAssertEqual(executions[0].result, 0)
    XCTAssertEqual(result, 0)
  }

  func test_arguments1_parameterOptional_returnBool_defaultNo() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments1_parameterOptional_returnBool_defaultNo_stub

    stub.register { _ in true }

    // when
    let result = stubClass.arguments1_parameterOptional_returnBool_defaultNo("String Parameter")

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments, "String Parameter")
    XCTAssertEqual(executions[0].result, true)
    XCTAssertEqual(result, true)
  }

  func test_arguments1_parameterOptional_returnBool_defaultBool() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments1_parameterOptional_returnBool_defaultBool_stub

    // when
    let result = stubClass.arguments1_parameterOptional_returnBool_defaultBool("String Value")

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments, "String Value")
    XCTAssertEqual(executions[0].result, false)
    XCTAssertEqual(result, false)
  }

  func test_arguments2_parameterOptional_returnBool_defaultNo() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments2_parameterOptional_returnBool_defaultNo_stub

    stub.register { _ in true }

    // when
    let result = stubClass.arguments2_parameterOptional_returnBool_defaultNo("String1", "String2")

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments.0, "String1")
    XCTAssertEqual(executions[0].arguments.1, "String2")
    XCTAssertEqual(executions[0].result, true)
    XCTAssertEqual(result, true)
  }

  func test_arguments2_parameterOptional_returnBool_defaultBool() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments2_parameterOptional_returnBool_defaultBool_stub

    // when
    let result = stubClass.arguments2_parameterOptional_returnBool_defaultBool("String Value1", "String Value2")

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments.0, "String Value1")
    XCTAssertEqual(executions[0].arguments.1, "String Value2")
    XCTAssertEqual(executions[0].result, false)
    XCTAssertEqual(result, false)
  }

  func test_arguments3_returnOptionalString_defaultNo() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments3_returnOptionalString_defaultNo_stub

    stub.register { _ in "Test" }

    // when
    let result = stubClass.arguments3_returnOptionalString_defaultNo("Hello", 10, 20)

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments.0, "Hello")
    XCTAssertEqual(executions[0].arguments.1, 10)
    XCTAssertEqual(executions[0].arguments.2, 20)
    XCTAssertEqual(executions[0].result, "Test")
    XCTAssertEqual(result, "Test")
  }

  func test_arguments3_returnOptionalString_defaultString() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments3_returnOptionalString_defaultString_stub

    // when
    let result = stubClass.arguments3_returnOptionalString_defaultString("Hello", 10, 20)

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments.0, "Hello")
    XCTAssertEqual(executions[0].arguments.1, 10)
    XCTAssertEqual(executions[0].arguments.2, 20)
    XCTAssertEqual(executions[0].result, "default")
    XCTAssertEqual(result, "default")
  }

  func test_arguments0_returnOptionalInt_defaultNil() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments0_returnOptionalInt_defaultNil_stub

    // when
    let result = stubClass.arguments0_returnOptionalInt_defaultNil()

    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertNil(executions[0].result)
    XCTAssertNil(result)
  }

  func test_arguments2_returnString_defaultNo_throws() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments2_returnString_defaultNo_throws_stub

    stub.register { _ in "Stubbed" }

    // when
    let result = try? stubClass.arguments2_returnString_defaultNo_throws("Hello", 30)

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments.0, "Hello")
    XCTAssertEqual(executions[0].arguments.1, 30)
    XCTAssertEqual(executions[0].result, "Stubbed")
    XCTAssertEqual(result, "Stubbed")
  }

  func test_arguments2_returnString_defaultString_throws() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments2_returnString_defaultString_throws_stub

    // when
    let result = try? stubClass.arguments2_returnString_defaultString_throws("Hello", 30)

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments.0, "Hello")
    XCTAssertEqual(executions[0].arguments.1, 30)
    XCTAssertEqual(executions[0].result, "default")
    XCTAssertEqual(result, "default")
  }

  func test_arguments_1_generic() {
    // given
    let stubClass = StubClass()
    let stub = stubClass.arguments_1_generic_stubStore.stub(arguments: String.self, result: String.self)

    stub.register { _ in "Stubbed" }

    // when
    let result: String = stubClass.arguments_1_generic("Hi")

    // then
    let executions = stub.executions()
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments, "Hi")
    XCTAssertEqual(executions[0].result, "Stubbed")
    XCTAssertEqual(result, "Stubbed")
  }

  func testThreadSafety() {
    // given
    let stubClass = StubClass()

    // when & then (must have to not crash)
    for _ in 0..<100 {
      DispatchQueue.global().async(execute: stubClass.sleep)
    }
    XCTWaiter().wait(for: [XCTestExpectation()], timeout: 10)

    // then
    let executions = stubClass.sleep_stub.executions()
    XCTAssertEqual(executions.count, 100)
  }

  func testClosureCrash() {
    // given
    final class ImageManager {
      @StubProxy(requestImage) var requestImageStub
      func requestImage(for asset: AnyObject, resultHandler: (() -> Void)? = nil) {
        requestImageStub.invoke((asset, resultHandler))
      }
    }

    let imageManager = ImageManager()
    imageManager.requestImage(for: NSObject())

    let executions = imageManager.requestImageStub.executions()

    // crash
    _ = executions.first?.arguments.0
    imageManager.requestImageStub.clear()
  }

  func testMatcherArgumentsNil() {
    // given
    final class Foo {
      @StubProxy(doSomething) var doSomethingStub
      func doSomething(with arg: String?) {
        doSomethingStub.invoke(arg)
      }
    }

    func expect<T>(_ value: T, toHaveCount count: Int, file: StaticString = #file, line: UInt = #line, where: @escaping (T.Iterator.Element) -> Bool) where T: Collection {
      XCTAssertEqual(value.filter(`where`).count, count, file: file, line: line)
    }

    let foo = Foo()
    foo.doSomething(with: nil)

    let executions = foo.doSomethingStub.executions()
    expect(executions, toHaveCount: 1) {
      $0.arguments == nil
    }
  }
}
