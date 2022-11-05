//
//  BookResponse.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation

struct BookResponse: Decodable {

    
    //MARK: - Properties
    
    let totalItems: Int
    let items: [BookItem]
    
    
    //MARK: - Parse enum
    
    enum CodingKeys: String, CodingKey {
        case totalItems
        case items
    }
}
