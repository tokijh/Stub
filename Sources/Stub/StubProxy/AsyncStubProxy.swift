//
//  AsyncStubProxy.swift
//  
//
//  Created by 윤중현 on 2022/11/05.
//

#if swift(>=5.6) && canImport(_Concurrency)

@propertyWrapper
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct AsyncStubProxy<Arguments, Result> {
  public let wrappedValue: AsyncStub<Arguments, Result>

  public init(arguments: Arguments.Type, result: Result.Type) {
    self.wrappedValue = AsyncStub(arguments: arguments, result: result)
  }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncStubProxy {
  public init<Service>(_ function: (Service) -> (Arguments) async throws -> Result) {
    self.init(arguments: Arguments.self, result: Result.self)
  }

  public init<Service>(_ function: (Service) -> () async throws -> Result) where Arguments == Void {
    self.init(arguments: Arguments.self, result: Result.self)
  }
}

#endif
