//
//  StatDetailView.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import SwiftUI

enum StatKind: Hashable {
    case considering
    case valueOnHold
    case savedByPassing
    case spentOnBuys
}

struct StatDetailView: View {
    let kind: StatKind

    @EnvironmentObject var controller: FindController
    @Environment(\.dismiss) private var dismiss

    // MARK: - Data for each kind

    private var finds: [Find] {
        switch kind {
        case .considering, .valueOnHold: return controller.consideringFinds
        case .savedByPassing: return controller.passedFinds
        case .spentOnBuys: return controller.boughtFinds
        }
    }

    private var title: String {
        switch kind {
        case .considering: return "Considering"
        case .valueOnHold: return "Value on Hold"
        case .savedByPassing: return "Saved by Passing"
        case .spentOnBuys: return "Spent on Buys"
        }
    }

    private var iconName: String {
        switch kind {
        case .considering: return "clock"
        case .valueOnHold: return "pause"
        case .savedByPassing: return "banknote"
        case .spentOnBuys: return "bag"
        }
    }

    private var headline: String {
        switch kind {
        case .considering: return "\(controller.totalConsidering)"
        case .valueOnHold: return Currency.string(controller.totalValueOnHold)
        case .savedByPassing: return Currency.string(controller.totalSavedByPassing)
        case .spentOnBuys: return Currency.string(controller.totalSpentOnBuys)
        }
    }

    private var caption: String {
        switch kind {
        case .considering: return finds.count == 1 ? "find in the pause zone" : "finds in the pause zone"
        case .valueOnHold: return "staying put for now"
        case .savedByPassing: return "kept in your pocket"
        case .spentOnBuys: return "on thoughtful yeses"
        }
    }

    private var emptyTitle: String {
        switch kind {
        case .considering: return "Your pause zone is clear"
        case .valueOnHold: return "No money on hold"
        case .savedByPassing: return "Your savings story starts here"
        case .spentOnBuys: return "No buys yet"
        }
    }

    private var emptyMessage: String {
        switch kind {
        case .considering: return "New maybes will wait here while you decide without the rush."
        case .valueOnHold: return "When you pause a find, its price will add up here."
        case .savedByPassing: return "Every thoughtful pass becomes a tiny win worth celebrating."
        case .spentOnBuys: return "When a considered find earns a yes, its total will live here."
        }
    }

    private var listHeading: String {
        switch finds.count {
        case 0: return "No finds yet"
        case 1: return "1 recent find"
        default: return "\(finds.count) recent finds"
        }
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // SUMMARY CARD
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color("NiftyYellow"))
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: iconName)
                                .foregroundColor(Color("NiftyRed"))
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(headline)
                            .font(.calSans(size: 30))
                            .foregroundColor(Color("NiftyRed"))
                        Text(caption)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color("NiftyRed"))
                    }
                    Spacer()
                }
                .padding(16)
                .background(Color("NiftyGreen"))
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.1), radius: 6, y: 3)

                Text(listHeading)
                    .font(.calSans(size: 14))
                    .foregroundColor(Color("NiftyRed"))

                if finds.isEmpty {
                    MascotEmptyState(title: emptyTitle, message: emptyMessage)
                        .padding(.top, 40)
                } else {
                    VStack(spacing: 16) {
                        ForEach(finds) { find in
                            NavigationLink(value: find.id) {
                                DashboardFindCard(
                                    image: find.image,
                                    findName: find.findName,
                                    price: Currency.string(find.price),
                                    status: find.status.displayName
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // FOOTER
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                    Text("That’s the whole nifty picture.")
                }
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color("NiftyGreen"))
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("NiftyRed"))
                }
            }
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.calSans(size: 17))
                    .foregroundColor(Color("NiftyRed"))
            }
        }
    }
}

#Preview {
    NavigationStack {
        StatDetailView(kind: .considering)
    }
    .environmentObject(FindController())
}
