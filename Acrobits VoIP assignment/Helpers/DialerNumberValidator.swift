//
//  DialerNumberValidator.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import Foundation

class DialerNumberValidator {
  static func isValidNumber(number: String) -> Bool {
    guard !number.isEmpty else { return false }
    return number.allSatisfy { $0.isNumber }
  }
}
