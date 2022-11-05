//
//  BookData.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation

struct BookData: Decodable {
    
    
    //MARK: - Properties
    
    let title: String
    let authors: [String]
    let publishedDate: String?
    let description: String?
    let imageLinks: BookDataImage?
    
    
    //MARK: - Parse enum
    
    enum CodingKeys: String, CodingKey {
        case title
        case authors
        case publishedDate
        case description
        case imageLinks
    }
}
