//
//  FindDetailView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/29/26.
//

import SwiftUI

struct FindDetailView: View {
    @EnvironmentObject var controller: FindController
    private let initialFind: Find
    var onBack: () -> Void

    /// Always the latest saved version of this find, so edits show up right away.
    private var find: Find { controller.find(id: initialFind.id) ?? initialFind }

    init(find: Find, onBack: @escaping () -> Void) {
        self.initialFind = find
        self.onBack = onBack
    }

    @State private var showBuyConfirmation = false
    @State private var showPassConfirmation = false
    @State private var showOptionsMenu = false
    @State private var showDeleteConfirmation = false
    @State private var showEdit = false
    @State private var decision: FindDecision?

    var body: some View {
        Group {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // FIND PHOTO DISPLAY / PLACEHOLDER
                        if let imageData = find.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("NiftyRed"), style: StrokeStyle(lineWidth: 2, dash: [6]))
                                .frame(maxWidth: .infinity)
                                .frame(height: 220)
                                .overlay {
                                    VStack(spacing: 4) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 28))
                                            .foregroundColor(Color("NiftyRed"))
                                        Text("FIND PHOTO")
                                            .font(.calSans(size: 12))
                                            .bold()
                                            .foregroundColor(Color("NiftyRed"))
                                    }
                                }
                        }

                        // TITLE, STORE / BRAND & PRICE HEADER
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(find.findName)
                                    .font(.calSans(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text([find.brand, find.storeName].filter { !$0.isEmpty }.joined(separator: " · "))
                                    .font(.calSans(size: 13))
                                    .foregroundColor(Color("NiftyYellow"))
                            }
                            
                            Spacer()
                            
                            Text("\(Currency.string(find.price))")
                                .font(.calSans(size: 26))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        // DETAIL CARD COMPONENT
                        FindDetailCard(
                            condition: conditionString(for: find.condition),
                            issues: find.issues.isEmpty ? "None specified" : find.issues,
                            repairNotes: find.repairNotes.isEmpty ? "None specified" : find.repairNotes,
                            personalNotes: find.personalNotes.isEmpty ? "None specified" : find.personalNotes
                        )

                        // PASS & BUY ACTION BUTTONS
                        HStack(spacing: 12) {
                            Button {
                                showPassConfirmation = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark")
                                    Text("Pass")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("NiftyRed"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .cornerRadius(12)
                            }

                            Button {
                                showBuyConfirmation = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "bag")
                                    Text("Buy")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color("NiftyRed"))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 4)
                        .disabled(find.status != .considering)
                        .opacity(find.status == .considering ? 1 : 0.5)

                        if find.status != .considering {
                            Text("This find is already marked as \(find.status.rawValue).")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color("NiftyRed"))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                    }
                    .padding()
                }
                .background(Color("NiftyGreen"))
                .navigationTitle("Find Detail")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $showEdit) {
                    EditFindView(find: find, onBack: { showEdit = false })
                }
                .fullScreenCover(item: $decision) { decision in
                    DecisionSuccessView(decision: decision) {
                        self.decision = nil
                        onBack()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            onBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("NiftyRed"))
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showOptionsMenu = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color("NiftyRed"))
                        }
                    }
                }

                // CUSTOM BUY DIALOG OVERLAY
                if showBuyConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showBuyConfirmation = false }

                    CustomDialogBox(
                        mascot: .bringHome,
                        title: "Bring it home?",
                        message: "Mark these \(find.findName.lowercased()) as bought for \(Currency.string(find.price))?",
                        primaryButtonTitle: "Yes",
                        secondaryButtonTitle: "Not Yet",
                        primaryAction: {
                            showBuyConfirmation = false
                            let snapshot = find
                            if controller.markAsBought(snapshot) {
                                decision = FindDecision(outcome: .bought, findName: snapshot.findName, amount: snapshot.price)
                            }
                        },
                        secondaryAction: {
                            showBuyConfirmation = false
                        }
                    )
                    .padding(.horizontal, 24)
                }

                // CUSTOM PASS DIALOG OVERLAY
                if showPassConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showPassConfirmation = false }

                    CustomDialogBox(
                        mascot: .letGo,
                        title: "Let this one go?",
                        message: "Passing saves \(Currency.string(find.price)) and keeps your closet breathing. Nice call.",
                        primaryButtonTitle: "Pass & Save \(Currency.string(find.price))",
                        secondaryButtonTitle: "Keep Considering",
                        primaryAction: {
                            showPassConfirmation = false
                            let snapshot = find
                            if controller.markAsPassed(snapshot) {
                                decision = FindDecision(outcome: .passed, findName: snapshot.findName, amount: snapshot.price)
                            }
                        },
                        secondaryAction: {
                            showPassConfirmation = false
                        }
                    )
                    .padding(.horizontal, 24)
                }

                // CUSTOM DELETE DIALOG OVERLAY
                if showDeleteConfirmation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showDeleteConfirmation = false }

                    CustomDialogBox(
                        mascot: .toss,
                        title: "Delete this find?",
                        message: "This will permanently remove \(find.findName). This can't be undone.",
                        primaryButtonTitle: "Delete Find",
                        secondaryButtonTitle: "Keep Find",
                        primaryAction: {
                            showDeleteConfirmation = false
                            if controller.deleteFind(find) {
                                onBack()
                            }
                        },
                        secondaryAction: {
                            showDeleteConfirmation = false
                        }
                    )
                    .padding(.horizontal, 24)
                }

                // CUSTOM OPTIONS BOTTOM SHEET MENU OVERLAY
                if showOptionsMenu {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showOptionsMenu = false }

                    VStack {
                        Spacer()
                        FindOptionsMenuSheet(
                            onEdit: {
                                showOptionsMenu = false
                                showEdit = true
                            },
                            onDelete: {
                                showOptionsMenu = false
                                showDeleteConfirmation = true
                            },
                            onCancel: {
                                showOptionsMenu = false
                            }
                        )
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: showOptionsMenu)
                }
            }
        }
    }

    private func conditionString(for condition: FindCondition) -> String {
        switch condition {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .needsRepair: return "Needs Repair"
        case .heavilyWorn: return "Heavily Worn"
        }
    }
}

// Reusable Custom Dialog Box
struct CustomDialogBox: View {
    var mascot: Mascot
    var title: String
    var message: String
    var primaryButtonTitle: String
    var secondaryButtonTitle: String
    var primaryAction: () -> Void
    var secondaryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Mascot
            MascotImage(mascot: mascot, size: 90)
                .padding(.top, 8)

            // Titles & Message
            VStack(spacing: 8) {
                Text(title)
                    .font(.calSans(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color("NiftyRed"))

                Text(message)
                    .font(.calSans(size: 13))
                    .foregroundColor(Color("NiftyGreen"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            // Action Buttons
            VStack(spacing: 10) {
                Button(action: primaryAction) {
                    Text(primaryButtonTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("NiftyRed"))
                        .cornerRadius(12)
                }

                Button(action: secondaryAction) {
                    Text(secondaryButtonTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color("NiftyRed"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("NiftyRed"), lineWidth: 1.5)
                        )
                        .cornerRadius(12)
                }
            }
            .padding(.top, 4)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
    }
}

// Custom Bottom Sheet Options Menu
struct FindOptionsMenuSheet: View {
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Drag Indicator Bar
            HStack {
                Spacer()
                Capsule()
                    .fill(Color("NiftyGreen"))
                    .frame(width: 36, height: 5)
                Spacer()
            }
            .padding(.top, 4)

            // Title
            Text("Find options")
                .font(.calSans(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color("NiftyRed"))

            // Edit Find Button
            Button(action: onEdit) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                        .font(.system(size: 15, weight: .medium))
                    Text("Edit Find")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(Color("NiftyRed"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color("NiftyGreen"))
                .cornerRadius(12)
            }

            // Delete Find Button
            Button(action: onDelete) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                        .font(.system(size: 15, weight: .medium))
                    Text("Delete Find")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color("NiftyRed"))
                .cornerRadius(12)
            }

            // Cancel Button
            Button(action: onCancel) {
                Text("Cancel")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color("NiftyRed"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("NiftyRed"), lineWidth: 1.5)
                    )
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
    }
}

// Extension to round specific corners for bottom sheets
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

/// Used by the Dashboard and Finds list: opens the detail screen and goes back by popping the navigation stack.
struct FindDetailScreen: View {
    let find: Find
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        FindDetailView(find: find, onBack: { dismiss() })
    }
}

#Preview {
    FindDetailView(
        find: Find(
            findName: "Cherry red loafers",
            price: 46.0,
            storeName: "Vinted",
            brand: "Merry People",
            condition: .good,
            issues: "Light scuff on the right toe; soles still have plenty of life.",
            repairNotes: "Try leather balm",
            personalNotes: "Would replace my pair",
            status: .considering,
            image: nil
        ),
        onBack: {}
    )
    .environmentObject(FindController())
}
