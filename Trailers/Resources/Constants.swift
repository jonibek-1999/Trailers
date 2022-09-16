//
//  Constants.swift
//  Netflix Clone
//
//  Created by ithink on 10/09/22.
//

import Foundation
import UIKit
import AVFoundation

struct Color {
    static let mainColor = UIColor(named: "mainColor")
    static let secondaryColor = UIColor(named: "secondaryColor")
    static let buttonColor = UIColor(named: "buttonColor")
    static let darkRedColor = UIColor(r: 186, g: 24, b: 27, a: 1)
    static let lightRedColor = UIColor(r: 229, g: 56, b: 59, a: 1)
    // new comment
}

enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case soft
    case rigid
    case selection
    case oldSchool
    
    func vibrate() {
        switch self {
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            if #available (iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        case .rigid:
            if #available (iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}
