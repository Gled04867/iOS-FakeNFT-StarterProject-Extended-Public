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
}
struct UpdateProfileDto: Encodable {
    let name: String
    let description: String
    let website: String
    let avatar: String?
}
