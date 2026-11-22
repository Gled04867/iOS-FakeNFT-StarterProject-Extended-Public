//
//  ProfileMenuRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 18.11.2026.
//

import SwiftUI

struct ProfileMenuRow: View {
    let title: String
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("\(title) (\(count))")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
