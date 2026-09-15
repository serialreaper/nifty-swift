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
        ScrollView {
            VStack(alignment: .leading) {
                Text("Nifty")
                    .font(.berkshireSwash(size: 50))
                    .foregroundStyle(Color("NiftyRed"))

                VStack {
                    HStack {
                        StatCard(value: "\(controller.totalConsidering)", label: "Total Considering", backgroundColor: Color("NiftyGreen"), textColor: .white, height: 140)
                        StatCard(value: "\(Int(controller.totalValueOnHold))", label: "Total Value on hold", backgroundColor: Color("NiftyRed"), textColor: .white, height: 180)
                    }
                    HStack {
                        StatCard(value: "\(Int(controller.totalSavedByPassing))", label: "Total Saved by passing", backgroundColor: Color("NiftyRed"), textColor: .white, height: 180)
                        StatCard(value: "\(Int(controller.totalSpentOnBuys))", label: "Total Spent on buys", backgroundColor: Color("NiftyGreen"), textColor: .white, height: 140)
                    }
                }

                Text("Still Considering")
                    .font(.calSans(size: 20))

                if controller.finds.isEmpty {
                    Text("Your thrift basket is empty.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 30)
                } else if controller.consideringFinds.isEmpty {
                    Text("You currently have no considering.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 30)
                } else {
                    VStack(spacing: 20) {
                        ForEach(controller.consideringFinds) { find in
                            DashboardFindCard(image: find.image, findName: find.findName, price: "P\(Int(find.price))", status: find.status.rawValue.capitalized)
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(FindController())
}
