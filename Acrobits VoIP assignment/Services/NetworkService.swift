//
//  NetworkService.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import Combine
import Softphone_Swift

/// Service to monitor network reachability status.
class NetworkService {
  @Published var isReachable: Bool = true // Alternatively we can make it enum with .notDetermined state to handle it differently on UI level. But based on assignment requirements it's probably overkill.

  func updateReachability(from type: NetworkType) {
    isReachable = type.rawValue != 0
  }
}
