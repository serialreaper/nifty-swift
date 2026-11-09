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
            
            
            Text("Nifty")
                .padding(.top, 35)
                .font(.berkshireSwash(size: 48))
                .foregroundStyle(Color.white)
            
            Text("Pause. Ponder. Pocket the win.")
                .font(.calSans(size: 20))
                .foregroundStyle(Color("NiftyYellow"))
            
            Spacer()
            
            Image("nifty-mascot")
                .resizable()
                .scaledToFit()
                .frame(width: 285, height: 285)
            
            Spacer()
            
            Text("A cheerful little pause between “ooh!” and “order confirmed.”")
                .padding(.horizontal, 60)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
            
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
        .background(Color("NiftyLightRed"))
    }
}

#Preview {
    SplashScreenView(goToDashboard: .constant(false))
        .environmentObject(FindController())
}
