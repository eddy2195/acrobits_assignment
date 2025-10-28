//
//  AcrobitsTests.swift
//  Acrobits VoIP assignment
//
//  Created by Star on 28/10/2025.
//

import XCTest
@testable import Acrobits_VoIP_assignment

// Was not able to run tests due to failures of loading test bundle on my machine. Will check later.
class DialerViewModelTests: XCTestCase {
  
  @MainActor
  func testInitialState() {
    let registrationService = RegistrationService()
    let networkService = NetworkService()
    let outgoingCallService = OutgoingCallService()
    let userService = UserService()
    userService.updateName("Undefined")
    
    let viewModel = DialerViewModel(registrationService: registrationService,
                                    networkService: networkService,
                                    outgoingCallService: outgoingCallService,
                                    userService: userService)
    
    XCTAssertEqual(viewModel.displayName, "Undefined")
    XCTAssertEqual(viewModel.registratorState, .notRegistered)
    XCTAssertEqual(viewModel.phoneNumber, "")
    XCTAssertTrue(viewModel.isNetworkAvailable)
    XCTAssertFalse(viewModel.showAlert)
    XCTAssertFalse(viewModel.canDial)
  }
  
  @MainActor
  func testDialButtonEnabledState() {
    let registrationService = RegistrationService()
    let networkService = NetworkService()
    let outgoingCallService = OutgoingCallService()
    let userService = UserService()
    userService.updateName("Undefined")
    
    let viewModel = DialerViewModel(registrationService: registrationService,
                                    networkService: networkService,
                                    outgoingCallService: outgoingCallService,
                                    userService: userService)
    networkService.isReachable = true
    
    viewModel.handleKeyPress("3")
    viewModel.handleKeyPress("1")
    viewModel.handleKeyPress("0")
    viewModel.handleKeyPress("1")
    
    registrationService.registrationState = .registered
    
    XCTAssertEqual(viewModel.displayName, "Undefined")
    XCTAssertEqual(viewModel.registratorState, .registered)
    XCTAssertEqual(viewModel.phoneNumber, "3101")
    XCTAssertTrue(viewModel.isNetworkAvailable)
    XCTAssertFalse(viewModel.showAlert)
    XCTAssertTrue(viewModel.canDial)
  }
  
  @MainActor
  func testDialButtonDisabledNotRegisteredState() {
    let registrationService = RegistrationService()
    let networkService = NetworkService()
    let outgoingCallService = OutgoingCallService()
    let userService = UserService()
    userService.updateName("Undefined")
    
    let viewModel = DialerViewModel(registrationService: registrationService,
                                    networkService: networkService,
                                    outgoingCallService: outgoingCallService,
                                    userService: userService)
    networkService.isReachable = true
    
    viewModel.handleKeyPress("3")
    viewModel.handleKeyPress("1")
    viewModel.handleKeyPress("0")
    viewModel.handleKeyPress("1")
    
    registrationService.registrationState = .unauthorized
    
    XCTAssertEqual(viewModel.displayName, "Undefined")
    XCTAssertEqual(viewModel.registratorState, .unauthorized)
    XCTAssertEqual(viewModel.phoneNumber, "3101")
    XCTAssertTrue(viewModel.isNetworkAvailable)
    XCTAssertFalse(viewModel.showAlert)
    XCTAssertTrue(viewModel.canDial)
  }
  
  @MainActor
  func testDialButtonDisabledNoNetworkState() {
    let registrationService = RegistrationService()
    let networkService = NetworkService()
    let outgoingCallService = OutgoingCallService()
    let userService = UserService()
    userService.updateName("Undefined")
    
    let viewModel = DialerViewModel(registrationService: registrationService,
                                    networkService: networkService,
                                    outgoingCallService: outgoingCallService,
                                    userService: userService)
    networkService.isReachable = false
    
    viewModel.handleKeyPress("3")
    viewModel.handleKeyPress("1")
    viewModel.handleKeyPress("0")
    viewModel.handleKeyPress("1")
    
    registrationService.registrationState = .registered
    
    XCTAssertEqual(viewModel.displayName, "Undefined")
    XCTAssertEqual(viewModel.registratorState, .registered)
    XCTAssertEqual(viewModel.phoneNumber, "3101")
    XCTAssertFalse(viewModel.isNetworkAvailable)
    XCTAssertFalse(viewModel.showAlert)
    XCTAssertFalse(viewModel.canDial)
  }
  
  @MainActor
  func testDialButtonDisabledIncorrectPhoneState() {
    let registrationService = RegistrationService()
    let networkService = NetworkService()
    let outgoingCallService = OutgoingCallService()
    let userService = UserService()
    userService.updateName("Undefined")
    
    let viewModel = DialerViewModel(registrationService: registrationService,
                                    networkService: networkService,
                                    outgoingCallService: outgoingCallService,
                                    userService: userService)
    networkService.isReachable = true
    
    viewModel.handleKeyPress("0")
    viewModel.handleKeyPress("0")
    viewModel.handleKeyPress("0")
    viewModel.handleKeyPress("0")
    
    registrationService.registrationState = .registered
    
    XCTAssertEqual(viewModel.displayName, "Undefined")
    XCTAssertEqual(viewModel.registratorState, .registered)
    XCTAssertEqual(viewModel.phoneNumber, "000")
    XCTAssertTrue(viewModel.isNetworkAvailable)
    XCTAssertFalse(viewModel.showAlert)
    XCTAssertFalse(viewModel.canDial)
  }
}
