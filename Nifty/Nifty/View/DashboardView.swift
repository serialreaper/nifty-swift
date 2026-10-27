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
                        StatCard(value: "\(controller.totalConsidering)", label: "Considering", backgroundColor: Color("NiftyGreen"), textColor: Color("NiftyRed"), height: 98)
                        StatCard(value: "\(Int(controller.totalValueOnHold))", label: "Value on Hold", backgroundColor: Color("NiftyRed"), textColor: Color("NiftyGreen"), height: 98)
                    }
                    HStack {
                        StatCard(value: "\(Int(controller.totalSavedByPassing))", label: "Saved by Passing", backgroundColor: Color("NiftyRed"), textColor: Color("NiftyGreen"), height: 98)
                        StatCard(value: "\(Int(controller.totalSpentOnBuys))", label: "Spent on Buys", backgroundColor: Color("NiftyGreen"), textColor: Color("NiftyRed"), height: 98)
                    }
                }
                .padding(.bottom, 30)
                

                Text("Still Considering")
                    .font(.calSans(size: 20))

                if controller.finds.isEmpty {
                    Text("Nothing on your maybe pile")
                        .font(.calSans(size: 14))
                        .foregroundColor(Color("NiftyRed"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50)
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
            //.padding(.bottom, 80)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(FindController())
}
