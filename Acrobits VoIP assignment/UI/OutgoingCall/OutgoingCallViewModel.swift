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
  let calleeName: String
  let calleeNumber: String
  let outgoingCallService: OutgoingCallService
  
  private var cancellableSet = Set<AnyCancellable>()
  
  init(calleeName: String, calleeNumber: String, outgoingCallService: OutgoingCallService) {
    self.calleeName = calleeName
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
        case .terminated:
          self?.callState = .ended
          self?.dismiss = true
        default: break // TODO: handle other cases if needed
        }
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
    timer?.cancel()
  }
  
  func toggleMute() {
    isMuted.toggle()
  }
  
  func toggleHold() {
    isOnHold.toggle()
  }
}
