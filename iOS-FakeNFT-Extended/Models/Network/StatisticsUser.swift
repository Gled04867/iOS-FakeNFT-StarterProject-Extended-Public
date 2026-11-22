struct StatisticsUser: Decodable, Identifiable, Sendable {
    let id: String
    let name: String
    let avatar: String?
    let nfts: [String]
}
