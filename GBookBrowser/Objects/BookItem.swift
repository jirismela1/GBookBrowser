//
//  BookItem.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation

struct BookItem: Decodable {
    
    
    //MARK: - Properties
    
    let data: BookData
    let saleInfo: BookSaleInfo?
    
    
    //MARK: - Parse enum
    
    enum CodingKeys: String, CodingKey {
        case data = "volumeInfo"
        case saleInfo
    }
}
