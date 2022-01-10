//
//  NetworkError.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

enum NetworkError: Error {
    case unsupportedURL
    case network(Error?)
    case statusCodeError(Int)
    case noHTTPResponse
    case badData
    case queryTimeLimit
    case notModified // 304
    case badRequest //400
    case unAuthorized //401
    case forbidden //403
    case notFound //404
    case methodNotAllowed // 405
    case timeOut //408
    case unSupportedMediaType //415
    case validationFailed // 422
    case rateLimitted //429
    case serverError //500
    case serverUnavailable //503
    case gatewayTimeout //504
    case networkAuthenticationRequired //511
    case invalidImage
    case invalidMetadata
    case invalidToken
    case invalidURLRequest
    case invalidURL
    case unKnown
}
