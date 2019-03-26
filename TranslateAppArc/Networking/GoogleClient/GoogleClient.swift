//
//  GoogleClient.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 21/03/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import Foundation

class GoogleClient {
    
    static let apiKey = "AIzaSyB9KgxiWouUxpXcx4fzC0Tjkkvst4_NPpI"
    // https://translation.googleapis.com/language/translate/v2/languages?key=AIzaSyB9KgxiWouUxpXcx4fzC0Tjkkvst4_NPpI
    
    enum Endpoints {
        static let base = "https://translation.googleapis.com/"
        static let apiKeyParam = "?key=\(GoogleClient.apiKey)"
        static let pathTranslations = "language/translate/v2"
        static let pathLanguages = "language/translate/v2/languages"
        
        case getTranslation(String,String,String)
        case getLanguages
        
        
        var stringValue : String {
            switch self {
                //https://translation.googleapis.com/language/translate/v2?target=co&q=Hello&source=en&key=AIzaSyB9KgxiWouUxpXcx4fzC0Tjkkvst4_NPpI
            case .getTranslation(let q,let target,let source) : return Endpoints.base + Endpoints.pathTranslations + Endpoints.apiKeyParam + "&q=\(q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" + "&target=\(target.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" + "&source=\(source.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .getLanguages : return Endpoints.base + Endpoints.pathLanguages + Endpoints.apiKeyParam + "&target=en"
            }
        }
        
        var url:URL {
            return URL(string: stringValue)!
        }
    }
    
//    fileprivate func googleTranslateURLFromParameters(parameters : [String : AnyObject],path:String) -> URL {
//        
//        var components = URLComponents()
//        components.scheme = Constants.googleTranslate.scheme
//        components.host = Constants.googleTranslate.host
//        components.path = path
//        components.queryItems = [URLQueryItem]()
//        
//        for (key,value) in parameters {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            components.queryItems?.append(queryItem)
//        }
//        print("URL : \(components.url!)")
//        return components.url!
//    }
    
    class func taskForGetRequest<responseType:Decodable>(url : URL , responseType : responseType.Type,completion: @escaping (responseType?,Error?)->()){
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            print(url)
            
            guard error == nil else {
                print("Error On Internet Request")
                completion(nil,error!)
                return
            }
            
            guard let data = data else{
                let userInfo = [NSLocalizedDescriptionKey : "No data"]
                completion(nil,NSError(domain: "taskForGetRequest", code: 1, userInfo: userInfo))
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let responseObject = try decoder.decode(responseType.self, from: data)
                completion(responseObject,nil)
            }catch{
                completion(nil,error)
            }
            
        }
        task.resume()
    }
}
