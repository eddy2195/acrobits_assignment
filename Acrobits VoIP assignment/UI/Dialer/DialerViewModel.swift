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
  let outgoingCallService: OutgoingCallService
  let userService: UserService
  
  private var cancellableSet = Set<AnyCancellable>()
  
  init(
    registrationService: RegistrationService,
    networkService: NetworkService,
    outgoingCallService: OutgoingCallService,
    userService: UserService
  ) {
    self.registrationService = registrationService
    self.networkService = networkService
    self.outgoingCallService = outgoingCallService
    self.userService = userService
    
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
      initiateCall()
    } else {
      assertionFailure("Shouldn't be possible to press button. Check if button disabled")
      alertMessage = "Cannot place call. Check registration, network, and number."
      showAlert = true
    }
  }
  
  private func initiateCall() {
    let callResult = outgoingCallService.call(number: phoneNumber)
    
    if callResult == false {
      alertMessage = "Failed to initiate call. Please try again."
      showAlert = true
    }
  }
  
  private func setupBindings() {
    registrationService.$registrationState
      .sink { [weak self] state in
        self?.registratorState = state
        self?.updateValidation()
      }
      .store(in: &cancellableSet)
    
    networkService.$isReachable
      .sink { [weak self] isReachable in
        self?.isNetworkAvailable = isReachable
        self?.updateValidation()
      }
      .store(in: &cancellableSet)
    
    userService.$localUsername
      .sink { [weak self] name in
        self?.displayName = name
      }
      .store(in: &cancellableSet)
  }
  
  private func updateValidation() {
    canDial = registratorState == .registered && isNetworkAvailable && DialerNumberValidator.isValidNumber(number: phoneNumber)
  }
}
