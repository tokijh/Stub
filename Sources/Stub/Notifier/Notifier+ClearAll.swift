//
//  Stub+ClearAll.swift
//  Stub
//
//  Created by tokijh on 2022/04/18.
//  Copyright © 2022 tokijh. All rights reserved.
//

import Foundation

extension Stub {
  func subscribeClearAll() -> Notifier.Observer {
    Notifier.shared.observeClearAll { [weak self] in self?.clear() }
  }
}

extension Stub where Arguments == Any, Result == Any {
  public static func clearAll() {
    Notifier.shared.clearAll()
  }
}

extension Notifier {
  func clearAll() {
    notificationCenter.post(name: .clearAll, object: nil)
  }

  func observeClearAll(_ handler: @escaping () -> ()) -> Observer {
    let observer = notificationCenter.addObserver(
      forName: .clearAll,
      object: nil,
      queue: OperationQueue.main
    ) { _ in
      handler()
    }
    return Observer(observer: observer)
  }
}

extension Notification.Name {
  fileprivate static let clearAll = Notification.Name(rawValue: "Stub.Notifier.clearAll")
}
