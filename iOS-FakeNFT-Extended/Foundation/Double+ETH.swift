import Foundation

extension Double {
    var ethFormatted: String {
        formatted(.number.precision(.fractionLength(2))) + " ETH"
    }
}
