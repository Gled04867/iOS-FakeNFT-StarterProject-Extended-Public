import Foundation

struct Nft: Decodable, Sendable {
    let id: String
    let name: String
    let imagesURL: [URL]
    let rating: Int
    let price: Double
    let author: String
    let description: String
    let websiteURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imagesURL = "images"
        case rating
        case price
        case author
        case description
        case websiteURL = "website"
    }
}
