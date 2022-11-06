//
//  String+extension.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation

extension String {
    
    /**
     Returns string by key
     
     - returns: String
     */
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
