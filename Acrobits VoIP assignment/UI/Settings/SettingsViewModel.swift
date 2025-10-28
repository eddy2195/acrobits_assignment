//
//  SettingsViewModel.swift
//  Acrobits VoIP assignment
//
//  Created by Star on 28/10/2025.
//
import Combine

class SettingsViewModel: ObservableObject {
  @Published var displayName: String
  
  private let userService: UserService
  
  init(userService: UserService) {
    self.userService = userService
    self.displayName = userService.localUsername
  }
  
  func save() {
    userService.updateName(displayName)
  }
}
