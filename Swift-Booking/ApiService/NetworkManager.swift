//
//  NetworkManager.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import Foundation

class NetworkManager {
    
    struct Parameter {
        let key: String
        let value: String
        let type: String
        let contentType: String?
        let src: String?
        
        init(key: String, value: String, type: String, contentType: String? = nil, src: String? = nil) {
            self.key = key
            self.value = value
            self.type = type
            self.contentType = contentType
            self.src = src
        }
    }
    
    private let session: URLSession
    private let apiKey: String
    private let cookie: String
    
    init(apiKey: String, cookie: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.cookie = cookie
        self.session = session
    }
    
    func searchTable(date: String, time: String, person: String, latitude: String, longitude: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let parameters: [Parameter] = [
            Parameter(key: "date", value: date, type: "text"),
            Parameter(key: "time", value: time, type: "text"),
            Parameter(key: "person", value: "\(person)", type: "text"),
            Parameter(key: "latitude", value: latitude, type: "text"),
            Parameter(key: "longitude", value: longitude, type: "text")
        ]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        for param in parameters {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(param.key)\""
            if let contentType = param.contentType {
                body += "\r\nContent-Type: \(contentType)"
            }
            body += "\r\n\r\n\(param.value)\r\n"
            if let src = param.src {
                let fileData = try! Data(contentsOf: URL(fileURLWithPath: src))
                let fileContent = String(data: fileData, encoding: .utf8)!
                body += "; filename=\"\(src)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
        }
        body += "--\(boundary)--\r\n"
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://igmiweb.com/gladdenhub/Api/search_table")!, timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(cookie, forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                if responseString != "" {
                    completion(.success(data))
                }
            } else {
                let unknownError = NSError(domain: "GladdenHubAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                completion(.failure(unknownError))
            }
        }
        task.resume()
    }
}
