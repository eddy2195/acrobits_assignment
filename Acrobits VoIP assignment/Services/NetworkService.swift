//
//  NetworkService.swift
//  Acrobits VoIP assignment
//
//  Created by Star on 28/10/2025.
//

import Combine
import Softphone_Swift

class NetworkService {
  @Published var isReachable: Bool = false
  
  func updateReachability(from type: NetworkType) {
    isReachable = type.rawValue != 0
  }
}
