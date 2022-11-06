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
    
    
    //MARK: - Parse enum
    
    enum CodingKeys: String, CodingKey {
        case smallThumbnail
        case thumbnail
    }
    
    
    //MARK: - Functions
    
    /**
     Returns image link
     
     - returns: String?
     */
    func getImageLink() -> String? {
       if thumbnail != nil {
            return thumbnail
        } else if smallThumbnail != nil {
            return smallThumbnail
        }
        return nil
    }
}
