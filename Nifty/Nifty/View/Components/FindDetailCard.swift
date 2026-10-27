//
//  FindDetailCard.swift
//  Nifty
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI

struct FindDetailCard: View {
    
    let condition: String
    let issues: String
    let repairNotes: String
    let personalNotes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // CONDITION ROW
            HStack {
                Text("CONDITION")
                    .font(.calSans(size: 10))
                    .fontWeight(.bold)
                    .foregroundStyle(Color("NiftyGreen"))
                Spacer()
                Text(condition)
                    .font(.calSans(size: 13))
                    .foregroundStyle(Color("NiftyRed"))
            }
           
            // ISSUES
            VStack(alignment: .leading, spacing: 4) {
                Text("ISSUES")
                    .font(.calSans(size: 10))
                    .fontWeight(.bold)
                    .foregroundStyle(Color("NiftyGreen"))
               
                Text(issues)
                    .font(.calSans(size: 13))
                    .foregroundStyle(Color("NiftyRed"))
            }
           
            // REPAIR NOTES
            VStack(alignment: .leading, spacing: 4) {
                Text("REPAIR NOTES")
                    .font(.calSans(size: 10))
                    .fontWeight(.bold)
                    .foregroundStyle(Color("NiftyGreen"))
               
                Text(repairNotes)
                    .font(.calSans(size: 13))
                    .foregroundStyle(Color("NiftyRed"))
            }
           
            // PERSONAL NOTES
            VStack(alignment: .leading, spacing: 4) {
                Text("PERSONAL NOTES")
                    .font(.calSans(size: 10))
                    .fontWeight(.bold)
                    .foregroundStyle(Color("NiftyGreen"))
               
                Text(personalNotes)
                    .font(.calSans(size: 13))
                    .foregroundStyle(Color("NiftyRed"))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

#Preview {
    ZStack {
        Color("NiftyGreen").ignoresSafeArea()
        FindDetailCard(
            condition: "Good",
            issues: "Light scuff on the right toe; soles still have plenty of life.",
            repairNotes: "Try leather balm",
            personalNotes: "Would replace my pair"
        )
        .padding()
    }
}
