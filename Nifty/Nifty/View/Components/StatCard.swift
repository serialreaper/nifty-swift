//
//  StatCard.swift
//  Nifty
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI

struct StatCard: View {
    let value: String
    let label: String
    let backgroundColor: Color
    let textColor: Color
    let height: CGFloat
    
    var body: some View {
        VStack (alignment: .trailing) {
            Text(value)
                .font(.berkshireSwash(size: 80))
                .foregroundStyle(textColor)
            
            Text(label)
                .font(.calSans(size: 16))
                .foregroundStyle(textColor)
        }
        .frame(maxWidth: .infinity )
        .padding()
        .frame(height: height)
        .background(backgroundColor)
        .cornerRadius(26)
    }
}

#Preview {
    VStack {
        HStack {
            StatCard(value: "0", label: "Total Considering", backgroundColor: Color("NiftyGreen"), textColor: Color.white, height: 140)

            
            StatCard(value: "0", label: "Total Value on hold", backgroundColor: Color("NiftyRed"), textColor: Color.white, height: 180)
        }
        HStack {
            StatCard(value: "0", label: "Total Saved by passing", backgroundColor: Color("NiftyRed"), textColor: Color.white, height:180)
            
            StatCard(value: "0", label: "Total Spent on buys", backgroundColor: Color("NiftyGreen"), textColor: Color.white, height: 140)
        }
    }
}
