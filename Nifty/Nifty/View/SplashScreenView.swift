//
//  SplashScreenView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/3/26.
//

import SwiftUI

// SPLASH SCREEN VIEW - displays app name and button
struct SplashScreenView: View {
    @Binding var goToDashboard: Bool
    
    @EnvironmentObject var controller: FindController
    
    var body: some View {
        VStack {
            
            // TEXT
            Spacer()
            
            Text("Nifty")
                .font(.berkshireSwash(size: 77))
                .foregroundStyle(Color.white)
            
            Spacer()
            
            // BUTTON
            Button {
                goToDashboard = true
            } label: {
                Text("Get Started")
                    .font(.calSans(size: 20))
                    .frame(width: 197)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
            .tint(Color("NiftyGreen"))
            .foregroundStyle(Color.black)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("NiftyRed"))
    }
}

#Preview {
    SplashScreenView(goToDashboard: .constant(false))
        .environmentObject(FindController())
}
