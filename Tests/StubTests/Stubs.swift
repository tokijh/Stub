//
//  Stubs.swift
//  StubTests
//
//  Created by tokijh on 2022/04/18.
//  Copyright © 2022 tokijh. All rights reserved.
//

import Foundation

import Stub

final class StubClass {

  @StubProxy(arguments0_returnVoid_defaultNo)
  var arguments0_returnVoid_defaultNo_stub
  func arguments0_returnVoid_defaultNo() {
    arguments0_returnVoid_defaultNo_stub.invokeWithoutDefault()
  }
  @StubProxy(arguments0_returnVoid_defaultVoid)
  var arguments0_returnVoid_defaultVoid_stub
  func arguments0_returnVoid_defaultVoid() {
    arguments0_returnVoid_defaultVoid_stub.invoke()
  }

  @StubProxy(arguments1_returnInt_defaultNo)
  var arguments1_returnInt_defaultNo_stub
  func arguments1_returnInt_defaultNo(_ value: String) -> Int {
    arguments1_returnInt_defaultNo_stub.invokeWithoutDefault(value)
  }
  @StubProxy(arguments1_returnInt_defaultInt)
  var arguments1_returnInt_defaultInt_stub
  func arguments1_returnInt_defaultInt(_ value: String) -> Int {
    arguments1_returnInt_defaultInt_stub.invoke(value, default: 0)
  }

  @StubProxy(arguments1_parameterOptional_returnBool_defaultNo)
  var arguments1_parameterOptional_returnBool_defaultNo_stub
  func arguments1_parameterOptional_returnBool_defaultNo(_ value: String?) -> Bool {
    arguments1_parameterOptional_returnBool_defaultNo_stub.invokeWithoutDefault(value)
  }
  @StubProxy(arguments1_parameterOptional_returnBool_defaultBool)
  var arguments1_parameterOptional_returnBool_defaultBool_stub
  func arguments1_parameterOptional_returnBool_defaultBool(_ value: String?) -> Bool {
    arguments1_parameterOptional_returnBool_defaultBool_stub.invoke(value, default: false)
  }

  @StubProxy(arguments2_parameterOptional_returnBool_defaultNo)
  var arguments2_parameterOptional_returnBool_defaultNo_stub
  func arguments2_parameterOptional_returnBool_defaultNo(_ value1: String?, _ value2: String) -> Bool {
    arguments2_parameterOptional_returnBool_defaultNo_stub.invokeWithoutDefault((value1, value2))
  }
  @StubProxy(arguments2_parameterOptional_returnBool_defaultBool)
  var arguments2_parameterOptional_returnBool_defaultBool_stub
  func arguments2_parameterOptional_returnBool_defaultBool(_ value1: String?, _ value2: String) -> Bool {
    arguments2_parameterOptional_returnBool_defaultBool_stub.invoke((value1, value2), default: false)
  }

  @StubProxy(arguments3_returnOptionalString_defaultNo)
  var arguments3_returnOptionalString_defaultNo_stub
  func arguments3_returnOptionalString_defaultNo(_ value1: String, _ value2: Int, _ value3: Float) -> String? {
    arguments3_returnOptionalString_defaultNo_stub.invokeWithoutDefault((value1, value2, value3))
  }
  @StubProxy(arguments3_returnOptionalString_defaultString)
  var arguments3_returnOptionalString_defaultString_stub
  func arguments3_returnOptionalString_defaultString(_ value1: String, _ value2: Int, _ value3: Float) -> String? {
    arguments3_returnOptionalString_defaultString_stub.invoke((value1, value2, value3), default: "default")
  }

  @StubProxy(arguments0_returnOptionalInt_defaultNil)
  var arguments0_returnOptionalInt_defaultNil_stub
  func arguments0_returnOptionalInt_defaultNil() -> Int? {
    arguments0_returnOptionalInt_defaultNil_stub.invoke(default: nil)
  }

  @StubProxy(arguments2_returnString_defaultNo_throws)
  var arguments2_returnString_defaultNo_throws_stub
  func arguments2_returnString_defaultNo_throws(_ value1: String, _ value2: Int) throws -> String {
    try arguments2_returnString_defaultNo_throws_stub.invokeThrowWithoutDefault((value1, value2))
  }
  @StubProxy(arguments2_returnString_defaultString_throws)
  var arguments2_returnString_defaultString_throws_stub
  func arguments2_returnString_defaultString_throws(_ value1: String, _ value2: Int) throws -> String {
    arguments2_returnString_defaultString_throws_stub.invoke((value1, value2), default: "default")
  }

  @StubProxy(arguments_escapeClosure)
  var arguments_escapeClosure_stub
  func arguments_escapeClosure(_ value1: String, _ value2: @escaping (Bool) -> String) -> Void {
    arguments_escapeClosure_stub.invoke((value1, value2))
  }

  let arguments_1_generic_stubStore = StubStore()
  func arguments_1_generic<T>(_ value: T) -> T {
    let stub = arguments_1_generic_stubStore.stub(arguments: T.self, result: T.self)
    return stub.invokeWithoutDefault(value)
  }

  @StubProxy(sleep)
  var sleep_stub
  func sleep() {
    sleep_stub.invoke(default: { Foundation.sleep(1) }())
  }
}
