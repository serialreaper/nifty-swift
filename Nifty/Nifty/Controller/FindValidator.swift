//
//  FindValidator.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import Foundation

enum FindValidationError: LocalizedError, Equatable {
    case missingPhoto
    case missingName
    case missingPrice
    case invalidPrice
    case priceNotPositive
    case priceTooLarge
    case duplicate

    var errorDescription: String? {
        switch self {
        case .missingPhoto:
            return "Please add a photo of your find."
        case .missingName:
            return "Please give your find a name."
        case .missingPrice:
            return "Please enter a price."
        case .invalidPrice:
            return "The price must be a number, like 450 or 450.50."
        case .priceNotPositive:
            return "The price must be more than ₱0."
        case .priceTooLarge:
            return "That price looks too high. Please check it."
        case .duplicate:
            return "You already have a find with this name and price."
        }
    }
}

enum FindValidator {
    static let maxPrice: Double = 10_000_000

    /// Turns text like "₱1,250.50", "$46" or " 46 " into a number. Returns nil if it isn't a plain number.
    static func parsePrice(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: "₱", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else { return nil }

        let allowed = Set("0123456789.")
        guard cleaned.allSatisfy({ allowed.contains($0) }) else { return nil }
        guard cleaned.filter({ $0 == "." }).count <= 1 else { return nil }

        return Double(cleaned)
    }

    /// Checks everything about a find. Returns the parsed price on success.
    /// - Parameters:
    ///   - existing: the finds already saved (used for the duplicate check).
    ///   - excludingID: pass the find's own id when editing so it doesn't count as its own duplicate.
    static func validate(
        name: String,
        priceText: String,
        imageData: Data?,
        existing: [Find],
        excludingID: UUID? = nil
    ) -> Result<Double, FindValidationError> {

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return .failure(.missingName) }

        guard imageData != nil else { return .failure(.missingPhoto) }

        let trimmedPrice = priceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPrice.isEmpty else { return .failure(.missingPrice) }

        guard let price = parsePrice(trimmedPrice) else { return .failure(.invalidPrice) }
        guard price > 0 else { return .failure(.priceNotPositive) }
        guard price <= maxPrice else { return .failure(.priceTooLarge) }

        let isDuplicate = existing.contains { other in
            other.id != excludingID
            && other.findName.trimmingCharacters(in: .whitespacesAndNewlines)
                .caseInsensitiveCompare(trimmedName) == .orderedSame
            && abs(other.price - price) < 0.005
        }
        guard !isDuplicate else { return .failure(.duplicate) }

        return .success(price)
    }
}
