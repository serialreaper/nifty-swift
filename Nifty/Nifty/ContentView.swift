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
            if let startupError = controller.startupError {
                StorageErrorView(message: startupError)
            } else if goToDashboard {
                MainTabView()
            } else {
                SplashScreenView(goToDashboard: $goToDashboard)
            }
        }
        // Any failed database operation shows up here as a friendly alert.
        .alert("Something went wrong", isPresented: errorIsShowing) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(controller.errorMessage ?? "Please try again.")
        }
    }

    private var errorIsShowing: Binding<Bool> {
        Binding(
            get: { controller.errorMessage != nil },
            set: { isShowing in
                if !isShowing { controller.errorMessage = nil }
            }
        )
    }
}

/// Shown only if the database can't be opened at launch.
struct StorageErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color("NiftyYellow"))

            Text("Oops!")
                .font(.calSans(size: 28))
                .foregroundStyle(.white)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("NiftyRed"))
    }
}

#Preview {
    ContentView()
        .environmentObject(FindController())
}
