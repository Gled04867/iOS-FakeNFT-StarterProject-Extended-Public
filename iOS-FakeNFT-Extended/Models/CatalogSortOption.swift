//
//  CatalogSortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

enum CatalogSortOption: String, Identifiable, CaseIterable {
    case byName = "Sorting.byName"
    case byNftCount = "Sorting.byNftCount"

    var id: String {
        rawValue
    }

    var title: String {
        String(localized: String.LocalizationValue(rawValue))
    }

    var sortBy: String? {
        switch self {
        case .byName:
            return "name"
        case .byNftCount:
            return nil
        }
    }
}
