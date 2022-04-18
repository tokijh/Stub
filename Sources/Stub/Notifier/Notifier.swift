//
//  Notifier.swift
//  Stub
//
//  Created by tokijh on 2022/04/18.
//  Copyright © 2022 tokijh. All rights reserved.
//

import Foundation

final class Notifier {

  static let shared = Notifier()
  let notificationCenter = NotificationCenter()

  struct Observer {
    let observer: NSObjectProtocol
  }
}
