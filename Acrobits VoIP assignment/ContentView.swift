//
//  ContentView.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import SwiftUI

struct ContentView: View {
  let softphoneDelegate = SoftphoneDelegate()
  
  var body: some View {
    TabView {
      DialerView(
        viewModel: DialerViewModel(
          registrationService: softphoneDelegate.registrationService,
          networkService: softphoneDelegate.networkService,
          outgoingCallService: softphoneDelegate.outgoingCallService
        )
      )
      .tabItem {
        Image(systemName: "phone")
        Text("Dialer")
      }
      SettingsView()
        .tabItem {
          Image(systemName: "gearshape")
          Text("Settings")
        }
    }
  }
}

// Placeholder for the settings tab
struct SettingsView: View {
  var body: some View {
    Text("Settings")
      .font(.title)
      .foregroundColor(.secondary)
  }
}

#Preview {
  ContentView()
}
