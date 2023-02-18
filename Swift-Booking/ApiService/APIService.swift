//
//  APIService.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import Foundation
import Foundation

class APIService {
    static let shared = APIService()
    private let session = URLSession.shared
    private let baseURL = "https://igmiweb.com/gladdenhub/Api/search_table"
    private let apiKey = "NB10SKS20AS30"
   
    func searchTable(date: String?, time: String?, person: Int?, latitude: String, longitude: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        struct RequestBody: Encodable {
            let date: String?
            let time: String?
            let person: Int?
            let latitude: String
            let longitude: String
        }
        
        let requestBody = RequestBody(date: date!, time: time!, person: person!, latitude: latitude, longitude: longitude)
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.httpMethod = "POST"
        
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            request.httpBody = bodyData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

