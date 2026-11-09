//
//  DecisionSuccessView.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import SwiftUI

struct FindDecision: Identifiable {
    enum Outcome {
        case bought
        case passed
    }

    let id = UUID()
    let outcome: Outcome
    let findName: String
    let amount: Double
}

struct DecisionSuccessView: View {
    let decision: FindDecision
    var onDone: () -> Void

    private var isBought: Bool { decision.outcome == .bought }

    var body: some View {
        ZStack {
            (isBought ? Color("NiftyGreen") : Color("NiftyLightRed"))
                .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("✦ NIFTY DECISION ✦")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color("NiftyYellow"))

                    Text(isBought ? "A thoughtful yes!" : "Pocket that win!")
                        .font(.calSans(size: 36))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)

                // MASCOT
                MascotImage(mascot: isBought ? .bought : .passed, size: 170)

                // SUMMARY CARD
                VStack(spacing: 10) {
                    Text(decision.findName)
                        .font(.calSans(size: 20))
                        .foregroundColor(Color("NiftyRed"))
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(.system(size: 13))
                        .foregroundColor(Color("NiftyGreen"))
                        .multilineTextAlignment(.center)

                    HStack {
                        Text(isBought ? "SPENT WITH INTENTION" : "SAVED BY PASSING")
                            .font(.system(size: 11, weight: .bold))
                        Spacer()
                        Text(Currency.string(decision.amount))
                            .font(.calSans(size: 20))
                    }
                    .foregroundColor(Color("NiftyRed"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(isBought ? Color("NiftyGreen") : Color("NiftyYellow"))
                    .cornerRadius(10)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.12), radius: 10, y: 4)

                Spacer()

                Button(action: onDone) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.right")
                        Text(isBought ? "Back to Finds" : "Celebrate & Continue")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color("NiftyRed"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(isBought ? Color.white : Color("NiftyGreen"))
                    .cornerRadius(12)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
    }

    private var message: String {
        if isBought {
            return "You paused, checked the fit, and chose with confidence. That’s spending on purpose."
        } else {
            return "You let go of the rush and kept \(Currency.string(decision.amount)) for something better. Future-you says thanks."
        }
    }
}

#Preview("Bought") {
    DecisionSuccessView(
        decision: FindDecision(outcome: .bought, findName: "Cherry red loafers", amount: 46),
        onDone: {}
    )
}

#Preview("Passed") {
    DecisionSuccessView(
        decision: FindDecision(outcome: .passed, findName: "Cherry red loafers", amount: 46),
        onDone: {}
    )
}
