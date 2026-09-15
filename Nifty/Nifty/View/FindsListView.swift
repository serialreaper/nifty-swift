//
//  FindsListView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/11/26.
//

import SwiftUI

// FindsListView.swift
struct FindsListView: View {
    @EnvironmentObject var controller: FindController
    @State private var selectedFilter: FindFilter = .all

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("FINDS")
                    .font(.calSans(size: 20))

                HStack(spacing: 8) {
                    ForEach(FindFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedFilter == filter ? Color("NiftyGreen") : Color.white)
                            .foregroundColor(selectedFilter == filter ? .white : .black)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .onTapGesture {
                                selectedFilter = filter
                            }
                    }
                }
                .padding(.bottom, 20)

                let filteredFinds = controller.finds(for: selectedFilter)

                if filteredFinds.isEmpty {
                    Text("Your thrift basket is empty.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 30)
                } else {
                    VStack(spacing: 20) {
                        ForEach(filteredFinds) { find in
                            FindCard(image: find.image, findName: find.findName, price: "P\(Int(find.price))", condition: find.condition.rawValue.capitalized, status: find.status.rawValue.capitalized)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    FindsListView()
        .environmentObject(FindController())
}
