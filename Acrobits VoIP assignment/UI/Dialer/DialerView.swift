//
//  RegistratorState.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import SwiftUI

struct DialerView: View {
  @StateObject var viewModel: DialerViewModel
  
  private let keypadNumbers: [[String]] = [
    ["1", "2", "3"],
    ["4", "5", "6"],
    ["7", "8", "9"],
    ["+", "0", "⌫"]
  ]
  
  var body: some View {
    VStack(spacing: 0) {
      if !viewModel.isNetworkAvailable {
        Text("No network connection")
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.yellow)
          .foregroundColor(.black)
      }
      VStack(spacing: 4) {
        HStack {
          Text(viewModel.displayName)
            .font(.subheadline)
            .foregroundColor(.secondary)
          Spacer()
          Text(viewModel.registratorState.label)
            .foregroundColor(viewModel.registratorState.color)
            .padding(8)
            .background(viewModel.registratorState.color.opacity(0.1))
            .cornerRadius(8)
        }
        .padding(.horizontal)
        // Shrinking number display
        GeometryReader { geo in
          Text(viewModel.phoneNumber.isEmpty ? " " : viewModel.phoneNumber)
            .font(.system(size: 40, weight: .medium, design: .monospaced))
            .minimumScaleFactor(0.4)
            .lineLimit(1)
            .frame(width: geo.size.width, height: 60, alignment: .center)
            .animation(.easeInOut, value: viewModel.phoneNumber)
        }
        .frame(height: 60)
      }
      .padding(.top, 16)
      Spacer()
      // Keypad
      VStack(spacing: 12) {
        ForEach(0..<keypadNumbers.count, id: \.self) { row in
          HStack(spacing: 24) {
            ForEach(keypadNumbers[row], id: \.self) { key in
              Button(action: {
                viewModel.handleKeyPress(key)
              }) {
                ZStack {
                  if key == "⌫" {
                    Image(systemName: "delete.left")
                      .font(.system(size: 28))
                      .foregroundColor(viewModel.phoneNumber.isEmpty ? .gray : .primary)
                  } else {
                    Text(key)
                      .font(.system(size: 32, weight: .regular))
                      .foregroundColor(.primary)
                  }
                }
                .frame(width: 72, height: 72)
                .background(Color(.systemGray6))
                .clipShape(Circle())
              }
              .disabled(key == "⌫" && viewModel.phoneNumber.isEmpty)
            }
          }
        }
      }
      .padding(.bottom, 24)
      // Call button
      Button(action: {
        viewModel.call()
      }) {
        Image(systemName: "phone.fill")
          .font(.system(size: 32))
          .foregroundColor(.white)
          .frame(width: 72, height: 72)
          .background(viewModel.canDial ? Color.green : Color.gray)
          .clipShape(Circle())
      }
      .disabled(!viewModel.canDial)
      .padding(.bottom, 32)
    }
    .alert(isPresented: $viewModel.showAlert) {
      Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
    }
  }
}

#Preview {
  DialerView(viewModel: DialerViewModel(registrationService: RegistrationService(), networkService: NetworkService()))
}
