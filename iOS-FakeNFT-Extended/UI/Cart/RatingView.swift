import SwiftUI

struct RatingView: View {
    let rating: Int
    private let maxRating = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(.star)
                    .foregroundStyle(index <= rating ? Color.yellowUniversal : Color.ypLightGray)
            }
        }
    }
}

#Preview {
    RatingView(rating: 3)
}
