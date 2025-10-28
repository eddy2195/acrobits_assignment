//
//  SettingsView.swift
//  Acrobits VoIP assignment
//
//  Created by Star on 28/10/2025.
//

import SwiftUI

struct SettingsView: View {
  @StateObject var viewModel: SettingsViewModel
  @FocusState private var nameIsFocused: Bool
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Local User Display Name")) {
          TextField("Enter display name", text: $viewModel.displayName)
            .autocapitalization(.words)
            .focused($nameIsFocused)
        }
        Button("Save") {
          viewModel.save()
          nameIsFocused = false
        }
        .disabled(viewModel.displayName.isEmpty)
      }
      .navigationTitle("Settings")
    }
  }
}
