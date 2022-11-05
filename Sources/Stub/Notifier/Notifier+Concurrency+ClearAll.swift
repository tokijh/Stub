//
//  Notifier+Concurrency+ClearAll.swift
//  Stub
//
//  Created by tokijh on 2022/04/25.
//  Copyright © 2022 tokijh. All rights reserved.
//

#if swift(>=5.6) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncStub {
  func subscribeClearAll() -> Notifier.Observer {
    Notifier.shared.observeClearAll { [weak self] in
      guard let stub = self else { return }
      Task {
        await stub.clear()
      }
    }
  }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncStub where Arguments == Any, Result == Any {
  public static func clearAll() {
    Notifier.shared.clearAll()
  }
}

#endif
