//
//  DialerViewModel.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import Combine

@MainActor
class DialerViewModel: ObservableObject {
  @Published var displayName: String = "Undefined"
  @Published var registratorState: RegistratorState = .notRegistered
  @Published var phoneNumber: String = ""
  @Published var isNetworkAvailable: Bool = true
  @Published var showAlert: Bool = false
  @Published var alertMessage: String = ""
  @Published var canDial: Bool = false
  
  let registrationService: RegistrationService
  let networkService: NetworkService
  
  private var cancellableSet = Set<AnyCancellable>()
  
  init(registrationService: RegistrationService, networkService: NetworkService) {
    self.registrationService = registrationService
    self.networkService = networkService
    
    setupBindings()
  }
  
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
  
  func call() {
    if canDial {
      // Place call logic here
    } else {
      assertionFailure("Shouldn't be possible to press button. Check if button disabled")
      alertMessage = "Cannot place call. Check registration, network, and number."
      showAlert = true
    }
  }
  
  private func setupBindings() {
    registrationService.$registrationState
      .sink { [weak self] state in
        self?.registratorState = state
      }
      .store(in: &cancellableSet)
    
    networkService.$isReachable
      .sink { [weak self] isReachable in
        self?.isNetworkAvailable = isReachable
      }
      .store(in: &cancellableSet)
  }
  
  private func updateValidation() {
    canDial = registratorState == .registered && isNetworkAvailable && DialerNumberValidator.isValidNumber(number: phoneNumber)
  }
}
