//
//  AppDelegate.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 04.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        // show splash
        if let views = Bundle.main.loadNibNamed("LaunchView", owner: self, options: nil) {
            if views.count > 0 {
                if let splash = views[0] as? UIView {
                    // Add to view
                    self.window!.rootViewController!.view.addSubview(splash)
                    
                    // set contraints to superview edge
                    splash.translatesAutoresizingMaskIntoConstraints = false
                    splash.topAnchor.constraint(equalTo: splash.superview!.topAnchor).isActive = true
                    splash.bottomAnchor.constraint(equalTo: splash.superview!.bottomAnchor).isActive = true
                    splash.leadingAnchor.constraint(equalTo: splash.superview!.leadingAnchor).isActive = true
                    splash.trailingAnchor.constraint(equalTo: splash.superview!.trailingAnchor).isActive = true
                 
                    // schedule for dismis splash
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                        splash.removeFromSuperview()
                    }
                }
            }
        }

        return true
    }
}

