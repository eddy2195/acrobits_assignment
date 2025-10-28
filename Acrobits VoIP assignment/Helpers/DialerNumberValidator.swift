//
//  DialerNumberValidator.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import Foundation

class DialerNumberValidator {
  static func isValidNumber(number: String) -> Bool {
    if number == "3101" { // Special test number
      return true
    }
    
    let e164Regex = "^\\+[1-9]\\d{1,14}$"
    return number.range(of: e164Regex, options: .regularExpression) != nil
  }
}
