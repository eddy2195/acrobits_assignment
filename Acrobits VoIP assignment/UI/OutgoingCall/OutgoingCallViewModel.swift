//
//  OutgoingCallViewModel.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import SwiftUI
import Combine

@MainActor
class OutgoingCallViewModel: ObservableObject {
  enum CallState {
    case dialing
    case connected
    case ended
  }
  
  @Published var callState: CallState = .dialing
  @Published var callDuration: TimeInterval = 0
  @Published var isMuted: Bool = false
  @Published var isOnHold: Bool = false
  @Published var dismiss: Bool = false
  
  private var timer: AnyCancellable?
  var calleeName: String = "Unknown"
  let calleeNumber: String
  let outgoingCallService: OutgoingCallService
  
  private var cancellableSet = Set<AnyCancellable>()
  
  init(calleeNumber: String, outgoingCallService: OutgoingCallService) {
    self.calleeNumber = calleeNumber
    self.outgoingCallService = outgoingCallService
    
    setupBindings()
  }
  
  private func setupBindings() {
    outgoingCallService.$callState
      .sink { [weak self] state in
        switch state {
        case .trying:
          self?.callState = .dialing
        case .established:
          self?.callState = .connected
          self?.startTimer()
        case .terminated, .error:
          self?.callState = .ended
          self?.dismiss.toggle()
        default: break // TODO: handle other cases if needed
        }
      }
      .store(in: &cancellableSet)
        
    outgoingCallService.$currentCall
      .sink { [weak self] call in
        self?.calleeName = call?.accountName ?? "Unknown"
      }
      .store(in: &cancellableSet)
  }
  
  private func startTimer() {
    timer = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.callDuration += 1
      }
  }
  
  func hangUp() {
    callState = .ended
    guard let currentCall = outgoingCallService.currentCall else {
      assertionFailure("No current call to hang up")
      dismiss = true
      return
    }
    outgoingCallService.hangup(call: currentCall)
  }
  
  func toggleMute() {
    isMuted.toggle()
    outgoingCallService.muteCall()
  }
  
  func toggleHold() {
    isOnHold.toggle() // Should add some listener to update state based on actual call hold status
    outgoingCallService.holdCurrentCall()
  }
}
