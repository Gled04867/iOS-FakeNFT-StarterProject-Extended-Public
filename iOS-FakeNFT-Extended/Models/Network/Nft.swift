import Foundation

struct Nft: Decodable, Sendable {
    let id: String
    let name: String
    let imagesURL: [URL]
    let rating: Int
    let price: Double
    let author: String
    let description: String
    let website: URL

    enum CodingKeys: String, CodingKey {
        case id, name, rating, price, author, description, website
        case imagesURL = "images"
    }
}
