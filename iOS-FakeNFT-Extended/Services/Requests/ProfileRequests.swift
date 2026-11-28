//
//  ProfileRequests.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 26.11.2026.
//

import Foundation
struct GetProfileRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")
            }
        }

struct UpdateProfileRequest: NetworkRequest {
    let id: String
    let dto: Encodable?
    
    var endpoint: URL? {
        URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")
    }
    var httpMethod: HttpMethod { .put }
    var contentType: String { "application/x-www-form-urlencoded" }
}
struct UpdateProfileDto: Encodable {
    let name: String
    let description: String
    let website: String
    let avatar: String?
    
    
    func toFormURLEncoded() -> Data? {
        var components = URLComponents()
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "name", value: name))
        queryItems.append(URLQueryItem(name: "description", value: description))
        queryItems.append(URLQueryItem(name: "website", value: website))
        
        if let avatar = avatar, !avatar.isEmpty {
            queryItems.append(URLQueryItem(name: "avatar", value: avatar))
        }
        
        components.queryItems = queryItems
        
        return components.query?.data(using: .utf8)
    }
}
