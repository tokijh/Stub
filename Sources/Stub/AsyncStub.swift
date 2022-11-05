//
//  AsyncStub.swift
//  Stub
//
//  Created by tokijh on 2022/04/25.
//  Copyright © 2022 tokijh. All rights reserved.
//

#if swift(>=5.6) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public final class AsyncStub<Arguments, Result>: AnyStub {

  // MARK: Module

  public typealias Execution = Stub<Arguments, Result>.Execution
  public typealias Error = Stub<Arguments, Result>.Error

  // MARK: Properties

  private var stub: ((Arguments) async throws -> Result)?
  private let executionList: ExecutionList<Arguments, Result> = ExecutionList(executions: [])

  private var clearAllObserver: Notifier.Observer?

  public var isStubbing: Bool { self.stub != nil }


  // MARK: Initializer

  public init(arguments: Arguments.Type, result: Result.Type) {
    self.bind()
  }

  public convenience init(_ function: (Arguments) async throws -> Result) {
    self.init(arguments: Arguments.self, result: Result.self)
  }


  // MARK: Binding

  private func bind() {
    self.clearAllObserver = subscribeClearAll()
  }


  // MARK: Register

  public func register(_ function: @escaping (Arguments) async throws -> Result) async {
    self.stub = function
    await self.executionList.clear()
  }


  // MARK: Invoke

  public func invoke(
    _ arguments: Arguments,
    default: @autoclosure () async throws -> Result
  ) async rethrows -> Result {
    let result: Result = try await {
      if let stub = self.stub {
        return try await stub(arguments)
      } else {
        return try await `default`()
      }
    }()
    await self.executionList.append(execution: Execution(arguments: arguments, result: result))
    return result
  }

  public func invokeWithoutDefault(
    _ arguments: Arguments,
    file: StaticString = #file,
    line: UInt = #line,
    function: StaticString = #function
  ) async -> Result {
    guard let result = try? await self.stub?(arguments) else {
      preconditionFailure("⚠️ '\(function)' is not stubbed.", file: file, line: line)
    }
    await self.executionList.append(execution: Execution(arguments: arguments, result: result))
    return result
  }

  public func invokeThrowWithoutDefault(
    _ arguments: Arguments,
    file: StaticString = #file,
    line: UInt = #line,
    function: StaticString = #function
  ) async throws -> Result {
    guard let result = try await self.stub?(arguments) else {
      throw Error.notStubbed(function: function, file: file, line: line)
    }
    await self.executionList.append(execution: Execution(arguments: arguments, result: result))
    return result
  }


  // MARK: Executions

  public func executions() async -> [Execution<Arguments, Result>] {
    await self.executionList.executions
  }


  // MARK: Clear

  public func clear() async {
    self.stub = nil
    await self.executionList.clear()
  }

}


// MARK: Model

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncStub {

  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  private actor ExecutionList<Arguments, Result> {

    var executions: [Execution<Arguments, Result>]

    init(executions: [Execution<Arguments, Result>] = []) {
      self.executions = executions
    }

    func append(execution: Execution<Arguments, Result>) {
      executions.append(execution)
    }

    func clear() {
      executions = []
    }
  }

}


// MARK: Sugars

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncStub where Arguments == Void {
  public func invoke(default: Result) async -> Result {
    await self.invoke(Void(), default: `default`)
  }

  public func invokeWithoutDefault(
    file: StaticString = #file,
    line: UInt = #line,
    function: StaticString = #function
  ) async -> Result {
    await self.invokeWithoutDefault(Void(), file: file, line: line, function: function)
  }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncStub where Result == Void {
  public func invoke(_ arguments: Arguments) async -> Result {
    await self.invoke(arguments, default: Void())
  }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncStub where Arguments == Void, Result == Void {
  public func invoke() async -> Result {
    await self.invoke(Void(), default: Void())
  }
}

#endif
