//
//  MascotEmptyState.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import SwiftUI

struct MascotEmptyState: View {
    let label: String      // e.g. "MASCOT — CONSIDERING EMPTY"
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("NiftyRed"), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                .frame(width: 86, height: 86)
                .overlay {
                    VStack(spacing: 2) {
                        Text("N")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color("NiftyRed"))
                        Text(label)
                            .font(.system(size: 6, weight: .bold))
                            .foregroundColor(Color("NiftyRed"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                    }
                }
                .accessibilityHidden(true)

            Text(title)
                .font(.calSans(size: 20))
                .foregroundColor(Color("NiftyRed"))
                .multilineTextAlignment(.center)

            Text(message)
                .font(.system(size: 12))
                .foregroundColor(Color("NiftyGreen"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
    }
}

#Preview {
    MascotEmptyState(
        label: "MASCOT — CONSIDERING EMPTY",
        title: "Your pause zone is clear",
        message: "New maybes will wait here while you decide without the rush."
    )
}
