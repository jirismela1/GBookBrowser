//
//  UIView+extension.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 06.11.2022.
//

import UIKit

extension UIView {
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func transitionCrossDissolveAnimation(_ animation: (()->Void)?) {
        UIView.transition(with: self,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: animation,
                          completion: nil)
    }
}
