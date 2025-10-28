//
//  Untitled.swift
//  Acrobits VoIP assignment
//
//  Created by Star on 28/10/2025.
//

import Combine
import Softphone_Swift

class RegistrationService {
  @Published var registrationState: RegistratorState = .none
  
  func softphoneRegistrationUpdated(_ state: RegistratorStateType) {
    registrationState = RegistratorState(rawValue: Int(state.rawValue)) ?? .none
  }
}


