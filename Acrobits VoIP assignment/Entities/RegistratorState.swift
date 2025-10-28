//
//  RegistratorState.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import SwiftUI

enum RegistratorState {
  case none, discovering, notRegistered, pushHandshake, registering, registered, unregistering, unauthorized, error
  
  var label: String {
    switch self {
    case .none: return "None"
    case .discovering: return "Discovering"
    case .notRegistered: return "Not Registered"
    case .pushHandshake: return "Push Handshake"
    case .registering: return "Registering"
    case .registered: return "Registered"
    case .unregistering: return "Unregistering"
    case .unauthorized: return "Unauthorized"
    case .error: return "Error"
    }
  }
  
  var color: Color {
    switch self {
    case .registered: return .green
    case .unauthorized, .error: return .red
    default: return .gray
    }
  }
}
