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
        VStack (alignment: .leading) {

            
            Text(label)
                .font(.calSans(size: 14))
                .foregroundStyle(textColor)
                .padding(.trailing, 30)
            
            Spacer()
            Text(value)
                .font(.calSans(size: 26))
                .foregroundStyle(textColor)
                .padding(.trailing, 30)
            
        }
        .frame(maxWidth: .infinity )
        .padding()
        .frame(height: height)
        .background(backgroundColor)
        .cornerRadius(16)
    }
}

#Preview {
    VStack {
        HStack {
            StatCard(value: "0", label: "Considering", backgroundColor: Color("NiftyGreen"), textColor: Color.white, height: 98)

            
            StatCard(value: "0", label: "Value on Hold", backgroundColor: Color("NiftyRed"), textColor: Color.white, height: 98)
        }
        HStack {
            StatCard(value: "0", label: "Saved by Passing", backgroundColor: Color("NiftyRed"), textColor: Color.white, height:98)
            
            StatCard(value: "0", label: "Spent on Buys", backgroundColor: Color("NiftyGreen"), textColor: Color.white, height: 98)
        }
    }
    .padding()
}
