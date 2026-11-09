//
//  MascotImage.swift
//  Nifty
//
//  Created by Mac-LAB on 11/9/26.
//

import SwiftUI
import UIKit

enum Mascot {
    case empty      // empty states (no finds, no buys, no results)
    case toss       // "Toss this draft?" and "Delete this find?" dialogs
    case letGo      // "Let this one go?" dialog (Pass)
    case bringHome  // "Bring it home?" dialog (Buy)
    case bought     // "A thoughtful yes!" screen
    case passed     // "Pocket that win!" screen

    var assetName: String {
        switch self {
        case .empty: return "nifty-logo"
        case .toss: return "nifty-toss"
        case .letGo: return "nifty-go"
        case .bringHome: return "nifty-home"
        case .bought: return "nifty-bought"
        case .passed: return "nifty-passed"
        }
    }
}

struct MascotImage: View {
    let mascot: Mascot
    var size: CGFloat = 90

    private var resolvedName: String {
        UIImage(named: mascot.assetName) != nil ? mascot.assetName : "nifty-mascot"
    }

    var body: some View {
        Image(resolvedName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack {
        MascotImage(mascot: .empty)
        MascotImage(mascot: .toss)
        MascotImage(mascot: .letGo)
        MascotImage(mascot: .bringHome)
    }
}
