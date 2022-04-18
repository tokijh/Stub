//
//  Stub.swift
//  Stub
//
//  Created by tokijh on 2022/04/18.
//  Copyright © 2022 tokijh. All rights reserved.
//

import Foundation

public final class Stub<Arguments, Result>: AnyStub {

  // MARK: Module

  public enum Error: Swift.Error {
    case notStubbed(function: StaticString, file: StaticString, line: UInt)
  }

  // MARK: Properties

  private let lock = NSLock()
  private var stub: ((Arguments) throws -> Result)?
  private var _executions: [Execution<Arguments, Result>] = []

  private var clearAllObserver: Notifier.Observer?

  public var isStubbing: Bool { self.stub != nil }


  // MARK: Initializer

  public init(arguments: Arguments.Type, result: Result.Type) {
    self.bind()
  }

  public convenience init(_ function: (Arguments) throws -> Result) {
    self.init(arguments: Arguments.self, result: Result.self)
  }


  // MARK: Binding

  private func bind() {
    self.clearAllObserver = subscribeClearAll()
  }


  // MARK: Register

  public func register(_ function: @escaping (Arguments) throws -> Result) {
    self.lock.lock()
    self.stub = function
    self._executions = []
    self.lock.unlock()
  }


  // MARK: Invoke

  public func invoke(
    _ arguments: Arguments,
    default: @autoclosure () throws -> Result
  ) rethrows -> Result {
    let result: Result = try {
      if let stub = self.stub {
        return try stub(arguments)
      } else {
        return try `default`()
      }
    }()
    self.lock.lock()
    self._executions.append(Execution(arguments: arguments, result: result))
    self.lock.unlock()
    return result
  }

  public func invokeWithoutDefault(
    _ arguments: Arguments,
    file: StaticString = #file,
    line: UInt = #line,
    function: StaticString = #function
  ) -> Result {
    guard let result = try? self.stub?(arguments) else {
      preconditionFailure("⚠️ '\(function)' is not stubbed.", file: file, line: line)
    }
    self.lock.lock()
    self._executions.append(Execution(arguments: arguments, result: result))
    self.lock.unlock()
    return result
  }

  public func invokeThrowWithoutDefault(
    _ arguments: Arguments,
    file: StaticString = #file,
    line: UInt = #line,
    function: StaticString = #function
  ) throws -> Result {
    guard let result = try self.stub?(arguments) else {
      throw Error.notStubbed(function: function, file: file, line: line)
    }
    self.lock.lock()
    self._executions.append(Execution(arguments: arguments, result: result))
    self.lock.unlock()
    return result
  }


  // MARK: Executions
  
  public func executions() -> [Execution<Arguments, Result>] {
    self._executions
  }


  // MARK: Clear

  public func clear() {
    self.lock.lock()
    self.stub = nil
    self._executions = []
    self.lock.unlock()
  }

}


// MARK: Model

extension Stub {
  public struct Execution<Arguments, Result> {
    private let _arguments: Arguments
    public var arguments: Arguments { self._arguments }
    public let result: Result

    init(arguments: Arguments, result: Result) {
      self._arguments = arguments
      self.result = result
    }
  }
}


// MARK: Sugars

extension Stub where Arguments == Void {
  public func invoke(default: Result) -> Result {
    self.invoke(Void(), default: `default`)
  }

  public func invokeWithoutDefault(
    file: StaticString = #file,
    line: UInt = #line,
    function: StaticString = #function
  ) -> Result {
    self.invokeWithoutDefault(Void(), file: file, line: line, function: function)
  }
}

extension Stub where Result == Void {
  public func invoke(_ arguments: Arguments) -> Result {
    self.invoke(arguments, default: Void())
  }
}

extension Stub where Arguments == Void, Result == Void {
  public func invoke() -> Result {
    self.invoke(Void(), default: Void())
  }
}
