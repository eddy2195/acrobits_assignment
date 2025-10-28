//
//  ContentView.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import SwiftUI

struct ContentView: View {
  let softphoneDelegate = SoftphoneDelegate()
  let userService = UserService()
  
  var body: some View {
    TabView {
      DialerView(
        viewModel: DialerViewModel(
          registrationService: softphoneDelegate.registrationService,
          networkService: softphoneDelegate.networkService,
          outgoingCallService: softphoneDelegate.outgoingCallService,
          userService: userService
        )
      )
      .tabItem {
        Image(systemName: "phone")
        Text("Dialer")
      }
      SettingsView(viewModel: SettingsViewModel(userService: userService))
        .tabItem {
          Image(systemName: "gearshape")
          Text("Settings")
        }
    }
  }
}

#Preview {
  ContentView()
}
