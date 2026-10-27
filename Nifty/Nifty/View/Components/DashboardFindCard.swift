//
//  DashboardFindCard.swift
//  Nifty
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI

struct DashboardFindCard: View {
    let image: Data?
    let findName: String
    let price: String
    let status: String
    
    var body: some View {
        HStack {
            if let image, let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("NiftyGreen"))
                    .frame(width: 90, height: 90)
                    .overlay(Image(systemName: "tshirt").foregroundColor(Color("NiftyRed")))
            }
                
            VStack(alignment: .leading, spacing: 4) {
                Text(findName)
                    .font(.system(size: 14, weight: .bold, design: .default))
                
                Text(price)
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
                Text(status)
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundStyle(Color("NiftyGreen"))
            }
            .padding(.leading, 10)
            Spacer()
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DashboardFindCard(image: nil, findName: "Leopard", price: "P50", status: "Considering")
}
