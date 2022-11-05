//
//  BookDataSourceManager.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation
// pods
import Alamofire

class BookDataSourceManager {
    
    
    //MARK: - Properties
    
    private let apiKey = "AIzaSyC_f_LHMVJ_Z76QAXlPaanYGufcW5IhM_I"
    
    private let url = "https://www.googleapis.com/books/v1/volumes?q=inauthor:"
    
    
    private static var sharedManager: BookDataSourceManager?
    
    
    //MARK: - Singleton
    
    
    static func shared() -> BookDataSourceManager {
        if sharedManager == nil {
            sharedManager = BookDataSourceManager()
        }
        return sharedManager!
    }
    
    
    //MARK: - Functions
    
    func fetchBooks(by author: String = "", page: Int = 0, maxResults: Int = 40) -> DataRequest {
        
        var param: Parameters = [:]
        
        // set parameters
        param["maxResults"] = maxResults
        param["printType"] = "books"
        param["startIndex"] = page
        param["langRestrict"] = "cs"
        param["key"] = apiKey
        
        // request
        return AF.request(url + author.replacingOccurrences(of: " ", with: "+"), method: .get, parameters: param, encoding: URLEncoding.default).validate().responseDecodable(of: BookResponse.self) { response in
            switch response.result {
            case .success(let item):
                item.items.forEach({ item in
                    print(item.saleInfo?.buyLink)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
}
