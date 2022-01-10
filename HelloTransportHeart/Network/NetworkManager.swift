//
//  NetworkManager.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import UIKit

class NetworkManager {
    typealias JSONTaskCompletionHandler = (Decodable?, NetworkError?) -> Void
    
    var decoder: JSONDecoder
    private let urlSession: URLSession
    
    private var successCodes: CountableRange<Int> = 200..<299
    private var failureClientCodes: CountableRange<Int> = 400..<499
    private var failureBackendCodes: CountableRange<Int> = 500..<511
    
    enum EndPointType: String {
        case login
        case search
    }
    
    static let defaultHeaders = [
        "accept": "application/vnd.github.v3+json",
    ]
    
    internal static func buildHeaders(key: String, value: String) -> [String: String] {
        var headers = defaultHeaders
        headers[key] = value
        return headers
    }
    
    var showHeader: ((_ header: [String: String]) -> Void)?
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init())
    {
        self.urlSession = session
        self.decoder = decoder
    }
}

extension NetworkManager {
    func fetch<T: Decodable>(_ endpoint: EndPoint, decode: @escaping (Decodable) -> T?) async throws -> Result<T, NetworkError> {
        try Task.checkCancellation()
        
        do {
            return try await withCheckedThrowingContinuation({
                (continuation: CheckedContinuation<(Result<T, NetworkError>), Error>) in
                loadRequest(endpoint, decode: decode) { result in
                    switch result {
                        case .success(let data):
                            continuation.resume(returning: .success(data))
                        case .failure(let error):
                            continuation.resume(throwing: error)
                    }
                }
            })
        } catch NetworkError.unAuthorized  {
            return Result.failure(NetworkError.unAuthorized)
        } catch NetworkError.timeOut  {
            return Result.failure(NetworkError.timeOut)
        } catch NetworkError.invalidToken  {
            return Result.failure(NetworkError.invalidToken)
        } catch {
            print("fetch error \(error)")
            if let err = error as? NetworkError {
                return Result.failure(err)
            } else {
                return Result.failure(NetworkError.unKnown)
            }
            
        }
    }
    
    func fetch<T: Decodable>(_ endpoint: URL, decode: @escaping (Decodable) -> T?) async throws -> Result<T, NetworkError> {
        try Task.checkCancellation()
        
        do {
            return try await withCheckedThrowingContinuation({
                (continuation: CheckedContinuation<(Result<T, NetworkError>), Error>) in
                loadRequest(endpoint, decode: decode) { result in
                    switch result {
                        case .success(let data):
                            continuation.resume(returning: .success(data))
                        case .failure(let error):
                            continuation.resume(throwing: error)
                    }
                }
            })
        } catch NetworkError.unAuthorized  {
            return Result.failure(NetworkError.unAuthorized)
        } catch NetworkError.timeOut  {
            return Result.failure(NetworkError.timeOut)
        } catch NetworkError.invalidToken  {
            return Result.failure(NetworkError.invalidToken)
        } catch {
            print("fetch error \(error)")
            return Result.failure(NetworkError.unKnown)
        }
    }
}

// MARK: - Base
extension NetworkManager {
    
    @available(iOS 13.0.0, *)
    func loadRequest<T: Decodable>(_ endpoint: EndPoint, decode: @escaping (Decodable) -> T?, then handler: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = endpoint.url else {
            return
        }
        
        let request = buildBaseURLRequest(with: url)
        
        guard let request = request else {
            handler(Result.failure(NetworkError.invalidURLRequest))
            return
        }
       
        let task = decodingTaskWithConcurrency(with: request, decodingType: T.self) { (json , error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        handler(Result.failure(error))
                    }
                    return
                }

                if let value = decode(json) {
                    handler(.success(value))
                }
            }
        }
        task.resume()
    }
    
    func loadRequest<T: Decodable>(_ endpoint: URL, decode: @escaping (Decodable) -> T?, then handler: @escaping (Result<T, NetworkError>) -> Void) {
        
        let request = buildBaseURLRequest(with: endpoint)
        
        guard let request = request else {
            handler(Result.failure(NetworkError.invalidURLRequest))
            return
        }
       
        let task = decodingTaskWithConcurrency(with: request, decodingType: T.self) { (json , error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        handler(Result.failure(error))
                    }
                    return
                }

                if let value = decode(json) {
                    handler(.success(value))
                }
            }
        }
        task.resume()
    }

    @available(iOS 13.0.0, *)
    private func decodingTaskWithConcurrency<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                if let error = error {
                    
                    let errorCode = (error as NSError).code
                    
                    switch errorCode {
                        case NSURLErrorTimedOut:
                            completion(nil, NetworkError.timeOut)
                        default:
                            completion(nil, NetworkError.network(error))
                    }
                    return
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NetworkError.noHTTPResponse)
                return
            }
            
            self.serverResponeHeader(httpResponse: httpResponse)
            
            if self.successCodes.contains(httpResponse.statusCode) {
                
                guard let data = data else {
                    completion(nil, NetworkError.badData)
                    return
                }
                
                do {
                    let genericModel = try self.decoder.decode(decodingType, from: data)
                    completion(genericModel, nil)
                } catch {
                    completion(nil, NetworkError.network(error))
                }
                
            } else {
                completion(nil, self.handleHTTPResponse(statusCode: httpResponse.statusCode))
            }
        }
        
        return task
    }
    
    @available(iOS 15.0, *)
    func decodingTaskWithConcurrencyData<T: Decodable>(endPoint: URL, decodingType: T.Type) async throws -> Decodable? {
        let request = URLRequest(url: endPoint)
        let (data, metadataResponse) = try await URLSession.shared.data(for: request)
        guard (metadataResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.noHTTPResponse
        }

        return try self.decoder.decode(decodingType, from: data)
    }
}

extension NetworkManager {
    private func handleHTTPResponse(statusCode: Int) -> NetworkError {
       
        if self.failureClientCodes.contains(statusCode) { //400..<499
            switch statusCode {
                case 401:
                    return NetworkError.unAuthorized
                case 403:
                    return NetworkError.forbidden
                case 404:
                    return NetworkError.notFound
                case 405:
                    return NetworkError.methodNotAllowed
                case 408:
                    return NetworkError.timeOut
                case 415:
                    return NetworkError.unSupportedMediaType
                case 422:
                    return NetworkError.validationFailed
                case 429:
                    return NetworkError.rateLimitted
                default:
                    return NetworkError.statusCodeError(statusCode)
            }
            
        } else if self.failureBackendCodes.contains(statusCode) { //500..<511
            switch statusCode {
                case 500:
                    return NetworkError.serverError
                case 503:
                    return NetworkError.serverUnavailable
                case 504:
                    return NetworkError.gatewayTimeout
                case 511:
                    return NetworkError.networkAuthenticationRequired
                default:
                    return NetworkError.statusCodeError(statusCode)
            }
        } else {
            
            if statusCode == 999 {
                return NetworkError.unKnown
            }
            
            // Server returned response with status code different than expected `successCodes`.
            let info = [
                NSLocalizedDescriptionKey: "Request failed with code \(statusCode)",
                NSLocalizedFailureReasonErrorKey: "Wrong handling logic, wrong endpoint mapping."
            ]
            let error = NSError(domain: "NetworkService", code: statusCode, userInfo: info)
            return NetworkError.network(error)
        }
    }

    func buildBaseURLRequest(with endPoint: URL) -> URLRequest? {
        var request = URLRequest(url: endPoint, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let headers = NetworkManager.buildHeaders(key: "Content-Type", value: "application/json")
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }

    func serverResponeHeader(httpResponse: HTTPURLResponse) {
        if let header = httpResponse.allHeaderFields as? [String: String] {
            showHeader?(header)
        }
    }
    
    func serverResponeHeaderWithKey(httpResponse: HTTPURLResponse, targetKey: String) -> String? {
        if let targetStr = httpResponse.value(forHTTPHeaderField: targetKey) {
            return targetStr
        } else {
            return nil
        }
    }
}
