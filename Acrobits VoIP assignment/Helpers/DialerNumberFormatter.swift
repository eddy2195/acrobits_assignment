//
//  DialerNumberFormatter.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//
import Foundation

class DialerNumberFormatter {
  static func formatE164(input: String) -> String {
    // Remove non-digit except leading +
    let filtered = input.filter { $0.isNumber || $0 == "+" }
    if filtered.first == "+" {
      return "+" + filtered.dropFirst().filter { $0.isNumber }
    } else {
      return filtered
    }
  }
}
