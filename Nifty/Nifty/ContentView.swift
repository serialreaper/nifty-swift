//
//  ContentView.swift
//  Nifty
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: FindController
    
    @State private var goToDashboard = false
    
    var body: some View {
        Group {
            if goToDashboard {
                MainTabView()
            } else {
                SplashScreenView(goToDashboard: $goToDashboard)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FindController())
}
