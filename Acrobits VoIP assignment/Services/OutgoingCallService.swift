//
//  OutgoingCallService.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//
import Softphone_Swift

class OutgoingCallService {
  @Published var callState: CallStateTypeSwift = .unknown
  
  func softphoneCallStateUpdated(_ state: CallStateType) {
    callState = CallStateTypeSwift(rawValue: Int(state.rawValue)) ?? .unknown
  }
  
  func call(number: String) -> Bool {
    let call = SoftphoneCallEvent.create(withAccountId: "sip", uri: number)
    let stream = SoftphoneEventStream.load(SoftphoneStreamQuery.legacyCallHistoryStreamKey())
    
    call?.setStream(stream)
    call?.transients.set("voiceCall", forKey: "dialAction")
    
    let result = SoftphoneBridge.instance()?.events()?.post(call)
    debugPrint(result as Any)
    
    if result == PostResult_Success {
      return true
    }
    
    return false
  }
  
  func hangup(call: SoftphoneCallEvent) {
    SoftphoneBridge.instance()?.calls()?.close(call)
  }
}
