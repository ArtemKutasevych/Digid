//
//  NetworkService.swift
//  Digid
//
//  Created by Artem Kutasevych on 17.10.2023.
//
import Foundation
import UIKit

enum HTTPError: Error {
    case failedResponse
    case failedDecoding
    case invalidUrl
    case invalidData
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [String : String] {
        [:]
    }
}

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, HTTPError>) -> Void)
    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ())
    func cancelTaskBy(id: String)
}

final class DefaultNetworkService: NetworkService {
    private let session = URLSession.shared
    private let imageCache = NSCache<NSString, UIImage>()
    
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, HTTPError>) -> Void) {
    
        guard var urlComponent = URLComponents(string: request.url) else {
            return completion(.failure(.invalidUrl))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            return completion(.failure(.invalidUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                return completion(.failure(.failedResponse))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(.failedResponse)) //(NSError()))
                
            }
            
            guard let data = data else {
                
                return completion(.failure(.invalidData))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch {
                completion(.failure(.failedDecoding))
            }
        }
        .resume()
    }
    
    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            completion(imageFromCache)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, responce, error in
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(image)
                    self?.imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    func cancelTaskBy(id: String) {
        let urlString = id
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == url }.first?
                .cancel()
        }
    }
}
