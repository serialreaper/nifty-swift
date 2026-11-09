//
//  MascotEmptyState.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import SwiftUI

struct MascotEmptyState: View {
    var mascot: Mascot = .empty
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            MascotImage(mascot: mascot, size: 110)

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
        title: "Your pause zone is clear",
        message: "New maybes will wait here while you decide without the rush."
    )
}
