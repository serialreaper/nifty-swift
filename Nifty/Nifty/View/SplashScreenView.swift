//
//  SplashScreenView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/3/26.
//

import SwiftUI

// SPLASH SCREEN VIEW - displays app name and button
struct SplashScreenView: View {
    @State private var goToDashboard = false
    @EnvironmentObject var controller: FindController
    
    var body: some View {
        // VSTACK
        NavigationStack{
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
            .navigationDestination(isPresented: $goToDashboard) {
                MainTabView()
                .navigationBarBackButtonHidden(true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("NiftyRed"))
        }
        
        
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(FindController())
}
