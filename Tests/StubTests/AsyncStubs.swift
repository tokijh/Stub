//
//  Stubs.swift
//  StubTests
//
//  Created by tokijh on 2022/11/05.
//  Copyright © 2022 tokijh. All rights reserved.
//

#if swift(>=5.6) && canImport(_Concurrency)

import Stub

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
final class AsyncStubClass {

  @AsyncStubProxy(arguments0_returnVoid_defaultNo)
  var arguments0_returnVoid_defaultNo_stub
  func arguments0_returnVoid_defaultNo() async {
    await arguments0_returnVoid_defaultNo_stub.invoke()
  }
  @AsyncStubProxy(arguments0_returnVoid_defaultVoid)
  var arguments0_returnVoid_defaultVoid_stub
  func arguments0_returnVoid_defaultVoid() async {
    await arguments0_returnVoid_defaultVoid_stub.invoke()
  }

  @AsyncStubProxy(arguments1_returnInt_defaultNo)
  var arguments1_returnInt_defaultNo_stub
  func arguments1_returnInt_defaultNo(_ value: String) async -> Int {
    await arguments1_returnInt_defaultNo_stub.invokeWithoutDefault(value)
  }
  @AsyncStubProxy(arguments1_returnInt_defaultInt)
  var arguments1_returnInt_defaultInt_stub
  func arguments1_returnInt_defaultInt(_ value: String) async -> Int {
    await arguments1_returnInt_defaultInt_stub.invoke(value, default: 0)
  }

  @AsyncStubProxy(arguments1_parameterOptional_returnBool_defaultNo)
  var arguments1_parameterOptional_returnBool_defaultNo_stub
  func arguments1_parameterOptional_returnBool_defaultNo(_ value: String?) async -> Bool {
    await arguments1_parameterOptional_returnBool_defaultNo_stub.invokeWithoutDefault(value)
  }
  @AsyncStubProxy(arguments1_parameterOptional_returnBool_defaultBool)
  var arguments1_parameterOptional_returnBool_defaultBool_stub
  func arguments1_parameterOptional_returnBool_defaultBool(_ value: String?) async -> Bool {
    await arguments1_parameterOptional_returnBool_defaultBool_stub.invoke(value, default: false)
  }

  @AsyncStubProxy(arguments2_parameterOptional_returnBool_defaultNo)
  var arguments2_parameterOptional_returnBool_defaultNo_stub
  func arguments2_parameterOptional_returnBool_defaultNo(_ value1: String?, _ value2: String) async -> Bool {
    await arguments2_parameterOptional_returnBool_defaultNo_stub.invokeWithoutDefault((value1, value2))
  }
  @AsyncStubProxy(arguments2_parameterOptional_returnBool_defaultBool)
  var arguments2_parameterOptional_returnBool_defaultBool_stub
  func arguments2_parameterOptional_returnBool_defaultBool(_ value1: String?, _ value2: String) async -> Bool {
    await arguments2_parameterOptional_returnBool_defaultBool_stub.invoke((value1, value2), default: false)
  }

  @AsyncStubProxy(arguments3_returnOptionalString_defaultNo)
  var arguments3_returnOptionalString_defaultNo_stub
  func arguments3_returnOptionalString_defaultNo(_ value1: String, _ value2: Int, _ value3: Float) async -> String? {
    await arguments3_returnOptionalString_defaultNo_stub.invokeWithoutDefault((value1, value2, value3))
  }
  @AsyncStubProxy(arguments3_returnOptionalString_defaultString)
  var arguments3_returnOptionalString_defaultString_stub
  func arguments3_returnOptionalString_defaultString(_ value1: String, _ value2: Int, _ value3: Float) async -> String? {
    await arguments3_returnOptionalString_defaultString_stub.invoke((value1, value2, value3), default: "default")
  }

  @AsyncStubProxy(arguments0_returnOptionalInt_defaultNil)
  var arguments0_returnOptionalInt_defaultNil_stub
  func arguments0_returnOptionalInt_defaultNil() async -> Int? {
    await arguments0_returnOptionalInt_defaultNil_stub.invoke(default: nil)
  }

  @AsyncStubProxy(arguments2_returnString_defaultNo_throws)
  var arguments2_returnString_defaultNo_throws_stub
  func arguments2_returnString_defaultNo_throws(_ value1: String, _ value2: Int) async throws -> String {
    try await arguments2_returnString_defaultNo_throws_stub.invokeThrowWithoutDefault((value1, value2))
  }
  @AsyncStubProxy(arguments2_returnString_defaultString_throws)
  var arguments2_returnString_defaultString_throws_stub
  func arguments2_returnString_defaultString_throws(_ value1: String, _ value2: Int) async throws -> String {
    await arguments2_returnString_defaultString_throws_stub.invoke((value1, value2), default: "default")
  }

  @AsyncStubProxy(arguments_escapeClosure)
  var arguments_escapeClosure_stub
  func arguments_escapeClosure(_ value1: String, _ value2: @escaping (Bool) -> String) async -> Void {
    await arguments_escapeClosure_stub.invoke((value1, value2))
  }

  let arguments_1_generic_stubStore = StubStore()
  func arguments_1_generic<T>(_ value: T) async -> T {
    let stub = arguments_1_generic_stubStore.asyncStub(arguments: T.self, result: T.self)
    return await stub.invokeWithoutDefault(value)
  }

  @AsyncStubProxy(sleep)
  var sleep_stub
  func sleep() async throws {
    await sleep_stub.invoke(default: try await {
      try await Task.sleep(nanoseconds: 1_000_000_000) // 1s
    }())
  }
}

#endif
