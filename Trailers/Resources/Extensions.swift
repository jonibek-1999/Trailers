//
//  Extensions.swift
//  Netflix Clone
//
//  Created by ithink on 07/09/22.
//

import Foundation
import UIKit
import AVFoundation

// Get the CURRENT Date&Time

extension String {
    func getCurrentDataAndTime() -> String {
        // DATE
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormatter.string(from: date)
        // TIME
        let hour = Calendar.current.component(.hour, from: date)
        let minute = String(Calendar.current.component(.minute, from: date))
        let formattedMinute = minute.count == 1 ? "0\(minute)" : "\(minute)"
        let time = "\(hour):\(formattedMinute)"

        let current = "\(currentDate), \(time)"
        return current
    }
}

// Animation UIButton

extension UIButton {
    
    func pulseAnimate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.4
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}


// Play Sound when Button Clicked

extension UIButton {
    
    func sound() {
        
        guard let url = Bundle.main.url(forResource: "soft-tone", withExtension: "mp3") else {return}
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("Error!")
        }
    }
}

// Initialization UIColor with RGB+a

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: Double = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

// Navigation from Left Side Transition

extension UINavigationController {
    
    func pushFromLeftController(_ vc: UIViewController) {
        let transition = CATransition()
        transition.subtype = .fromLeft
        transition.type = .push
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.layer.add(transition, forKey: kCATransition)
        pushViewController(vc, animated: false)
    }
}

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}
