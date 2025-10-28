//
//  DialerViewModel.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import Combine

class DialerViewModel: ObservableObject {
  @Published var displayName: String = "Undefined"
  @Published var registratorState: RegistratorState = .notRegistered
  @Published var phoneNumber: String = ""
  @Published var isNetworkAvailable: Bool = true
  @Published var showAlert: Bool = false
  @Published var alertMessage: String = ""
  @Published var canDial: Bool = false
  
  func handleKeyPress(_ key: String) {
    switch key {
    case "⌫":
      if !phoneNumber.isEmpty {
        phoneNumber.removeLast()
      }
    case "+":
      if phoneNumber.isEmpty {
        phoneNumber.append("+")
      }
    default:
      if phoneNumber.count < 15 {
        phoneNumber.append(key)
      }
    }
    phoneNumber = DialerNumberFormatter.formatE164(input: phoneNumber)
    
    updateValidation()
  }
  
  private func updateValidation() {
    canDial = registratorState == .registered && isNetworkAvailable && DialerNumberValidator.isValidNumber(number: phoneNumber)
  }
}
