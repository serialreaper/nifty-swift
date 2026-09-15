//
//  NiftyApp.swift
//  Nifty
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

@main
struct NiftyApp: App {
    @StateObject private var findController = FindController()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(findController)
        }
    }
}


