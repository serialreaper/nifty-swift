//
//  Formatters.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import Foundation

enum Currency {
    static let symbol = "₱"

    /// 46 -> "₱46", 46.5 -> "₱46.50", 1250 -> "₱1,250"
    static func string(_ amount: Double) -> String {
        let isWhole = amount.rounded() == amount
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_PH")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = isWhole ? 0 : 2
        formatter.maximumFractionDigits = isWhole ? 0 : 2
        let number = formatter.string(from: NSNumber(value: amount)) ?? String(format: "%.2f", amount)
        return symbol + number
    }
}

extension FindCondition {
    /// "needsRepair" -> "Needs Repair"
    var displayName: String {
        switch self {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .needsRepair: return "Needs Repair"
        case .heavilyWorn: return "Heavily Worn"
        }
    }
}

extension FindStatus {
    /// "considering" -> "Considering"
    var displayName: String {
        rawValue.capitalized
    }
}
