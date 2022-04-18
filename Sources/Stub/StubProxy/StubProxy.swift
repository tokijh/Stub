//
//  StubProxy.swift
//  Stub
//
//  Created by tokijh on 2022/04/18.
//  Copyright © 2022 tokijh. All rights reserved.
//

@propertyWrapper
public struct StubProxy<Arguments, Result> {
  public let wrappedValue: Stub<Arguments, Result>

  public init(arguments: Arguments.Type, result: Result.Type) {
    self.wrappedValue = Stub(arguments: arguments, result: result)
  }
}

extension StubProxy {

  public init<Service>(_ function: (Service) -> (Arguments) throws -> Result) {
    self.init(arguments: Arguments.self, result: Result.self)
  }

  public init<Service>(_ function: (Service) -> () throws -> Result) where Arguments == Void {
    self.init(arguments: Arguments.self, result: Result.self)
  }

}
