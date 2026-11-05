//
//  NiftyApp.swift
//  Nifty
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

@main
struct NiftyApp: App {
    // persistent: true -> data is saved on the device and survives closing the app.
    @StateObject private var controller = FindController(persistent: true)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
        }
    }
}
