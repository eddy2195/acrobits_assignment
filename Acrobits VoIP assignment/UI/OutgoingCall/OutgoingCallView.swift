//
//  OutgoingCallView.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import SwiftUI

struct OutgoingCallView: View {
  @ObservedObject var viewModel: OutgoingCallViewModel
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(spacing: 32) {
      Spacer()
      
      VStack(spacing: 4) {
        Text(viewModel.calleeName)
          .font(.title)
          .fontWeight(.semibold)
        Text(viewModel.calleeNumber)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      
      Text(callStatusText)
        .font(.system(size: 22, weight: .medium, design: .monospaced))
        .padding(.top, 8)
      
      Spacer()
      
      HStack(spacing: 48) {
        Button(action: { viewModel.toggleMute() }) {
          VStack {
            Image(systemName: viewModel.isMuted ? "mic.slash.fill" : "mic.fill")
              .font(.system(size: 28))
            Text("Mute")
              .font(.caption)
          }
          .foregroundColor(viewModel.isMuted ? .orange : .primary)
        }
        
        Button(action: { viewModel.toggleHold() }) {
          VStack {
            Image(systemName: viewModel.isOnHold ? "pause.circle.fill" : "pause.circle")
              .font(.system(size: 28))
            Text("Hold")
              .font(.caption)
          }
          .foregroundColor(viewModel.isOnHold ? .orange : .primary)
        }
      }
      .padding(.bottom, 32)
      
      Button(action: {
        viewModel.hangUp()
      }) {
        Image(systemName: "phone.down.fill")
          .font(.system(size: 36))
          .foregroundColor(.white)
          .frame(width: 72, height: 72)
          .background(Color.red)
          .clipShape(Circle())
      }
      .padding(.bottom, 40)
    }
    .onChange(of: viewModel.dismiss) { _, shouldDismiss in
      dismiss()
   }
  }
  
  private var callStatusText: String {
    switch viewModel.callState {
    case .dialing:
      return "Dialing..."
    case .connected:
      let minutes = Int(viewModel.callDuration) / 60
      let seconds = Int(viewModel.callDuration) % 60
      return String(format: "%02d:%02d", minutes, seconds)
    case .ended:
      return "Call Ended"
    }
  }
}
