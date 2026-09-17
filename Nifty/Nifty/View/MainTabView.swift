//
//  MainTabView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/15/26.
//

import SwiftUI

enum AppTab {
    case home, add, search
}

struct MainTabView: View {
    @EnvironmentObject var controller: FindController
    
    @State private var selectedTab: AppTab = .home
    @State private var previousTab: AppTab = .home
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            // HOME
            DashboardView()
                .tabItem {
                    Label("", systemImage: "house.fill")
                }
                .tag(AppTab.home)
            
            // ADD FIND
            AddFindView(onBack: {
                selectedTab = previousTab
            })
            .tabItem {
                Label("", systemImage: "plus")
            }
            .tag(AppTab.add)
            
            // SEARCH
            FindsListView()
                .tabItem {
                    Label("", systemImage: "magnifyingglass")
                }
                .tag(AppTab.search)
        }
        .tint(Color("NiftyRed"))
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue != .add {
                previousTab = newValue
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(FindController())
}
