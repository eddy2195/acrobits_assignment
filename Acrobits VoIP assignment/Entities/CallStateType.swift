//
//  CallStateType.swift
//  Acrobits VoIP assignment
//
//  Created by Sasha on 28/10/2025.
//
import Foundation

enum CallStateTypeSwift: Int {
    case unknown
    case trying
    case ringing
    case busy
    case incomingAnswered
    case incomingTrying
    case incomingRinging
    case incomingIgnored
    case incomingRejected
    case incomingMissed
    case established
    case error
    case unauthorized
    case terminated
    case incomingForwarded
    case incomingAnsweredElsewhere
    case redirectedToAlternativeService
}
