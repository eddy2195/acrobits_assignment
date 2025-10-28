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
  @Published var isReachable: Bool = false
  
  func updateReachability(from type: NetworkType) {
    isReachable = type.rawValue != 0
  }
}
