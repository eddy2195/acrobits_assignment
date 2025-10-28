//
//  UserService.swift
//  Acrobits VoIP assignment
//
//  Created by Star on 28/10/2025.
//
import Combine

class UserService {
  private let usernameKey = "localUsernameKey"
  
  @Published var localUsername: String = ""
  
  init() {
    self.localUsername = KeychainHelper.get(forKey: usernameKey) ?? ""
  }
  
  func updateName(_ newName: String) {
    localUsername = newName
    KeychainHelper.set(newName, forKey: usernameKey)
  }
}
