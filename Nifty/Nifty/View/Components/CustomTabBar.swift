//
//  CustomTabBar.swift
//  Nifty
//
//  Created by Mac-LAB on 9/11/26.
//
/*
import SwiftUI

enum AppTab {
    case home, search
}

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    var onAddTapped: () -> Void

    var body: some View {
        HStack {
            Button {
                selectedTab = .home
            } label: {
                Image(systemName: "house.fill")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Button {
                onAddTapped()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 46, height: 46)
                    .background(Color("NiftyGreen"))
                    .clipShape(Circle())
            }

            Spacer()

            Button {
                selectedTab = .search
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color("NiftyRed")))
        .padding(.horizontal, 40)
    }
}
*/

