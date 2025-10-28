//
//  SoftphoneDelegate.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//

import Foundation
import Combine
import Softphone_Swift

/// Delegate to handle Softphone SDK events. And emit events for desired services.
class SoftphoneDelegate: NSObject {
  
  let registrationService = RegistrationService()
  let networkService = NetworkService()
  let outgoingCallService = OutgoingCallService()
  
  private let softphoneObserverProxy = SoftphoneObserverProxyBridge()
  private let licenseKey = "kvotvlf5jgcsejqkc8bji3d90p" // TODO: don't store keys in plain text. Add obfuscator for it.
  
  override init() {
    super.init()
    
    self.start()
  }
  
  private func start() {
    let license = """
         <root>
             <saas>
                 <identifier>\(licenseKey)</identifier>
             </saas>
         </root>
         """
    
    // This method is used for initializing an instance of SDK
    do {
      try SoftphoneBridge.initialize(license)
      registerAccount()
    } catch let error {
      print(error.localizedDescription)
      //TODO: handle error
    }
  }
  
  private func registerAccount() {
    let sipAccount = """
         <account id=\"sip\">
             <title>Sip Account</title>
             <username>3100</username>
             <password>misscom</password>
             <host>pbx.acrobits.cz</host>
             <transport>udp</transport>
         </account>
     """
    
    try? SoftphoneBridge.initialize(sipAccount) // TODO: handle error if needed
    
    softphoneObserverProxy.delegate = self;
    SoftphoneBridge.instance().setObserver(softphoneObserverProxy)
    
    let xml = XmlTree.parse(sipAccount)
    SoftphoneBridge.instance().registration().saveAccount(xml)
    SoftphoneBridge.instance().registration().updateAll()
  }
}

extension SoftphoneDelegate: SoftphoneDelegateBridge {
  func onRegistrationStateChanged(state: RegistratorStateType, accountId: String!) {
    print("Registration state changed: \(state.rawValue) for account: \(accountId ?? "nil")")
    registrationService.softphoneRegistrationUpdated(state)
  }
  
  func onNetworkChangeDetected(_ network: NetworkType) {
    print("Network change detected: \(network.rawValue)")
    networkService.updateReachability(from: network)
  }
  
  func onNewEvent(_ event: SoftphoneEvent!) {
    print("New event received: \(String(describing: event))")
  }
  
  func onCallStateChanged(state: CallStateType, call: SoftphoneCallEvent!) {
    print("Call state changed: \(state.rawValue) for call: \(String(describing: call))")
    outgoingCallService.currentCall = call
    outgoingCallService.softphoneCallStateUpdated(state)
  }
  
  func onHoldStateChanged(states: CallHoldStates!, call: SoftphoneCallEvent!) {
    print("Hold state changed: \(String(describing: states)) for call: \(String(describing: call))")
  }
  
  func onMediaStatusChanged(media: CallMediaStatus!, call: SoftphoneCallEvent!) {
    print("Media status changed: \(String(describing: media)) for call: \(String(describing: call))")
  }
  
  func onEventsChanged(events: SoftphoneChangedEvents!, streams: SoftphoneChangedStreams!) {
    print("Events changed: \(String(describing: events)), Streams changed: \(String(describing: streams))")
  }
  
}


