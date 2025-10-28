//
//  OutgoingCallService.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//
import Softphone_Swift

/// Service to manage outgoing calls.
class OutgoingCallService {
  @Published var callState: CallStateTypeSwift = .unknown
  @Published var currentCall: SoftphoneCallEvent?
  
  func softphoneCallStateUpdated(_ state: CallStateType) {
    callState = CallStateTypeSwift(rawValue: Int(state.rawValue)) ?? .unknown
  }
  
  /// Initiates a call to the specified number.
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
  
  /// Hangs up the specified call.
  func hangup(call: SoftphoneCallEvent) {
    SoftphoneBridge.instance()?.calls()?.close(call)
  }
  
  /// Holds or resumes the current call.
  func holdCurrentCall() {
    guard let call = currentCall else {
      return
    }
    let holdStates = SoftphoneBridge.instance()?.calls()?.isHeld(call)
    let newHeld = holdStates?.local != CallHoldState_Held
    
    if newHeld
    {
      SoftphoneBridge.instance()?.registration()?.includeNonStandardSipHeader(accountId: "sip",
                                                                              method: "INVITE",
                                                                              responseCode: "",
                                                                              name: "X-HoldCause",
                                                                              value: "button")
    }
    else
    {
      SoftphoneBridge.instance()?.registration()?.excludeNonStandardSipHeader(accountId: "sip",
                                                                              method: "INVITE",
                                                                              responseCode: "",
                                                                              name: "X-HoldCause")
    }
    
    SoftphoneBridge.instance()?.calls()?.setHeld(call, held: newHeld)
    
    if !newHeld
    {
      let size = SoftphoneBridge.instance()?.calls()?.conferences()?.getSize(call: call)
      
      if size == 1
      {
        // if we are putting a single call off-hold, make its group active to
        // make the microphone output mix-into the conversation, otherwise it
        // doesn't make much sense
        
        SoftphoneBridge.instance()?.calls()?.conferences()?.setActive(call: call)
      }
    }
  }
  
  /// Mutes or unmutes the current call.
  func muteCall() {
    let newMute = (SoftphoneBridge.instance()?.audio()?.isMuted())
    SoftphoneBridge.instance()?.audio()?.setMuted(!newMute!)
  }
}
