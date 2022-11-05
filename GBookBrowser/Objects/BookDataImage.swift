//
//  BookDataImage.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation

struct BookDataImage: Decodable {
    
    
    //MARK: - Properties
    
    let smallThumbnail: String?
    let thumbnail: String?
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
    
    
    //MARK: - Parse enum
    
    enum CodingKeys: String, CodingKey {
        case smallThumbnail
        case thumbnail
        case small
        case medium
        case large
        case extraLarge
    }
    
    
    //MARK: - Functions
    
    /**
     Returns image link
     
     - returns: String?
     */
    func getImageLink() -> String? {
        if extraLarge != nil {
            return extraLarge
        } else if large != nil {
            return large
        } else if medium != nil {
            return medium
        } else if small != nil {
            return small
        } else if thumbnail != nil {
            return thumbnail
        } else if smallThumbnail != nil {
            return smallThumbnail
        }
        return nil
    }
}
