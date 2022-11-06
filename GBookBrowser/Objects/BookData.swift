//
//  BookData.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation

struct BookData: Decodable {
    
    
    //MARK: - Properties
    
    let title: String?
    let authors: [String]?
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
    
    /**
     Returns published year
     
     - returns: String?
     */
    func getPublishedYear() -> String? {
        if publishedDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: publishedDate!) {
                guard let year = Calendar.current.dateComponents([.year], from: date).year else { return publishedDate }
                return String(year)
            }
        }
        return publishedDate
    }
}
