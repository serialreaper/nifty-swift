//
//  DashboardView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/4/26.
//

import SwiftUI

// DashboardView.swift
struct DashboardView: View {
    @EnvironmentObject var controller: FindController

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Nifty")
                        .font(.berkshireSwash(size: 50))
                        .foregroundStyle(Color("NiftyRed"))

                    VStack {
                        HStack {
                            statLink(.considering, value: "\(controller.totalConsidering)", label: "Considering", background: Color("NiftyGreen"), text: Color("NiftyRed"))
                            statLink(.valueOnHold, value: Currency.string(controller.totalValueOnHold), label: "Value on Hold", background: Color("NiftyRed"), text: Color("NiftyGreen"))
                        }
                        HStack {
                            statLink(.savedByPassing, value: Currency.string(controller.totalSavedByPassing), label: "Saved by Passing", background: Color("NiftyRed"), text: Color("NiftyGreen"))
                            statLink(.spentOnBuys, value: Currency.string(controller.totalSpentOnBuys), label: "Spent on Buys", background: Color("NiftyGreen"), text: Color("NiftyRed"))
                        }
                    }
                    .padding(.bottom, 30)

                    Text("Still Considering")
                        .font(.calSans(size: 20))

                    if controller.finds.isEmpty {
                        VStack(spacing: 8) {
                            Text("Nothing on your maybe pile")
                                .font(.calSans(size: 20))
                                .foregroundColor(Color("NiftyRed"))
                            Text("Spot something tempting? Add it here and give future-you a little breathing room.")
                                .font(.system(size: 14))
                                .foregroundColor(Color("NiftyGreen"))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50)
                        .padding(.horizontal, 24)
                    } else if controller.consideringFinds.isEmpty {
                        Text("You currently have no considering.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 30)
                    } else {
                        VStack(spacing: 20) {
                            ForEach(controller.consideringFinds) { find in
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
                }
                .padding()
            }
            .navigationDestination(for: StatKind.self) { kind in
                StatDetailView(kind: kind)
            }
            .navigationDestination(for: UUID.self) { id in
                if let find = controller.find(id: id) {
                    FindDetailScreen(find: find)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    /// A stat card that opens its detail screen when tapped.
    private func statLink(_ kind: StatKind, value: String, label: String, background: Color, text: Color) -> some View {
        NavigationLink(value: kind) {
            StatCard(value: value, label: label, backgroundColor: background, textColor: text, height: 98)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DashboardView()
        .environmentObject(FindController())
}
