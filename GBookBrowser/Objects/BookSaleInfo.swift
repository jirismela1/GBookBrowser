//
//  BookSaleInfo.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation

struct BookSaleInfo: Decodable {
    
    
    //MARK: - Properties
    
    let buyLink: String?
    
    
    //MARK: - Parse enum
    
    enum CodingKeys: String, CodingKey {
        case buyLink
    }
}
