//
//  ManagerBookDataSource.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import Foundation
// pods
import Alamofire

class ManagerBookDataSource {
    
    
    //MARK: - Properties
    
    private let apiKey = "AIzaSyC_f_LHMVJ_Z76QAXlPaanYGufcW5IhM_I"
    private let url = "https://www.googleapis.com/books/v1/volumes?q=inauthor:"
    var items = [BookItem]()
    private var totalItems = 0
    
    
    //MARK: - Singleton
    
    private static var sharedManager: ManagerBookDataSource?
    
    static func shared() -> ManagerBookDataSource {
        if sharedManager == nil {
            sharedManager = ManagerBookDataSource()
        }
        return sharedManager!
    }
    
    
    //MARK: - Functions
    
    /**
     Fetch data from api call
     
     - parameter author:            String
     - parameter resetDataSource:   Bool = false
     - parameter callback:          ((_ success: Bool)->Void)?
     
     - returns: DataRequest?
     */
    func loadBooks(by author: String, resetDataSource: Bool = false, callback: ((_ success: Bool)->Void)?) -> DataRequest? {
        
        if resetDataSource {
            items.removeAll()
            totalItems = 0
        }
        
        if items.count != totalItems || resetDataSource {
            
            var param: Parameters = [:]
            
            // set parameters
            param["maxResults"] = 40
            param["printType"] = "books"
            param["startIndex"] = items.count
            param["langRestrict"] = "cs"
            param["key"] = apiKey
            
            // request
            return AF.request(url + author.replacingOccurrences(of: " ", with: "+"), method: .get, parameters: param, encoding: URLEncoding.default).validate().responseDecodable(of: BookResponse.self) { response in
                switch response.result {
                case .success(let item):
                    self.totalItems = item.totalItems ?? 0
                    if let items = item.items {
                        self.items.append(contentsOf: items)
                    }
                    callback?(true)
                case .failure(_):
                    callback?(false)
                }
            }
        }
        
        return nil
    }
}
