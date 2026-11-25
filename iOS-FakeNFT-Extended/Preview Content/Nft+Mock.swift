import Foundation

#if DEBUG
extension Nft {
    static let mock = Nft(
        id: "1",
        name: "April",
        imagesURL: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")].compactMap { $0 },
        rating: 3,
        price: 1.78,
        author: "Author",
        description: "Description",
        websiteURL: URL(fileURLWithPath: "/")
    )
}
#endif
