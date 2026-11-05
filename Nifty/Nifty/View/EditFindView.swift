//
//  EditFindView.swift
//  Nifty
//
//  Created by Mac-LAB on 10/27/26.
//

import SwiftUI
import PhotosUI

struct EditFindView: View {
    @EnvironmentObject var controller: FindController
    var find: Find
    var onBack: () -> Void

    @State private var findName: String
    @State private var price: String
    @State private var storeFound: String
    @State private var brand: String
    @State private var condition: String
    @State private var issues: String
    @State private var repairNotes: String
    @State private var personalNotes: String

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?

    @State private var validationMessage: String?
    @State private var isLoadingPhoto = false
    @State private var showSavedToast = false
    @State private var showDiscardConfirm = false

    private let conditions = ["Excellent", "Good", "Needs Repair", "Heavily Worn"]

    init(find: Find, onBack: @escaping () -> Void) {
        self.find = find
        self.onBack = onBack

        // Initialize state variables with existing find data
        _findName = State(initialValue: find.findName)
        _price = State(initialValue: String(format: "%.2f", find.price))
        _storeFound = State(initialValue: find.storeName)
        _brand = State(initialValue: find.brand)
        _condition = State(initialValue: EditFindView.displayCondition(from: find.condition))
        _issues = State(initialValue: find.issues)
        _repairNotes = State(initialValue: find.repairNotes)
        _personalNotes = State(initialValue: find.personalNotes)
        _selectedImageData = State(initialValue: find.image)
    }

    var body: some View {
        Group {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    
                    if let validationMessage {
                        Text("* \(validationMessage)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("NiftyRed"))
                    }

                    // EDIT PHOTO BANNER / PICKER
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack(spacing: 12) {
                            // Image Preview Box
                            Group {
                                if let selectedImageData,
                                   let uiImage = UIImage(data: selectedImageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("NiftyRed"), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                                        .overlay {
                                            Image(systemName: "photo")
                                                .font(.system(size: 24))
                                                .foregroundColor(Color("NiftyRed"))
                                        }
                                }
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                            )

                            // Label Stack
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Find photo")
                                    .font(.calSans(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("NiftyRed"))

                                Text("Bright, centered, and easy to remember.")
                                    .font(.calSans(size: 11))
                                    .foregroundColor(Color("NiftyRed").opacity(0.8))
                                    .multilineTextAlignment(.leading)

                                Text("Change photo")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color("NiftyRed"))
                                    .underline()
                                    .padding(.top, 2)
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(Color("NiftyGreen"))
                        .cornerRadius(16)
                    }
                    .overlay {
                        if isLoadingPhoto {
                            ProgressView()
                                .tint(Color("NiftyRed"))
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newItem in
                        Task { await loadPhoto(from: newItem) }
                    }

                    // NAME & PRICE ROW
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("NAME", required: true)
                            customTextField(text: $findName, placeholder: "Vintage cherry loafers")
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("PRICE", required: true)
                            customTextField(text: $price, placeholder: "₱46.00", keyboard: .decimalPad)
                        }
                        .frame(width: 110)
                    }

                    // STORE & BRAND ROW
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("STORE")
                            customTextField(text: $storeFound, placeholder: "Vinted", icon: "house")
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("BRAND")
                            customTextField(text: $brand, placeholder: "Merry People", icon: "tag")
                        }
                    }

                    // CONDITION TAGS
                    fieldLabel("CONDITION", required: true)
                    HStack(spacing: 8) {
                        ForEach(conditions, id: \.self) { option in
                            Text(option)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(
                                    condition == option
                                    ? Color("NiftyRed")
                                    : Color(.white)
                                )
                                .foregroundColor(
                                    condition == option
                                    ? .white
                                    : Color("NiftyRed")
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            condition == option ? Color.clear : Color("NiftyRed"),
                                            lineWidth: 1.5
                                        )
                                )
                                .cornerRadius(8)
                                .onTapGesture {
                                    condition = option
                                }
                        }
                    }

                    // ISSUES
                    VStack(alignment: .leading, spacing: 6) {
                        fieldLabel("ISSUES")
                        customTextField(text: $issues, placeholder: "Light scuff on right toe")
                    }

                    // REPAIR NOTES
                    VStack(alignment: .leading, spacing: 6) {
                        fieldLabel("REPAIR NOTES")
                        customTextField(text: $repairNotes, placeholder: "Try leather balm")
                    }

                    // PERSONAL NOTES
                    VStack(alignment: .leading, spacing: 6) {
                        fieldLabel("PERSONAL NOTES")
                        customTextField(text: $personalNotes, placeholder: "Would replace my old pair")
                    }

                    // SAVE CHANGES BUTTON
                    Button {
                        saveChanges()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark")
                            Text("Save Changes")
                        }
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("NiftyRed"))
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)
                    .disabled(showSavedToast)

                }
                .padding()
            }
            .overlay(alignment: .bottom) { savedToast }
            .animation(.easeInOut, value: showSavedToast)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Edit Find")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if hasUnsavedChanges {
                            showDiscardConfirm = true
                        } else {
                            onBack()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("NiftyRed"))
                    }
                }
            }
            .alert("Discard changes?", isPresented: $showDiscardConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Discard", role: .destructive) {
                    onBack()
                }
            } message: {
                Text("Your changes haven't been saved. If you leave now, your edits will be lost.")
            }
        }
    }

    private var hasUnsavedChanges: Bool {
        findName != find.findName ||
        price != String(format: "%.2f", find.price) ||
        storeFound != find.storeName ||
        brand != find.brand ||
        condition != EditFindView.displayCondition(from: find.condition) ||
        issues != find.issues ||
        repairNotes != find.repairNotes ||
        personalNotes != find.personalNotes ||
        selectedImageData != find.image
    }

    private func fieldLabel(_ text: String, required: Bool = false) -> some View {
        Text(required ? "\(text)*" : text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(Color("NiftyRed"))
    }

    @ViewBuilder
    private func customTextField(text: Binding<String>, placeholder: String, icon: String? = nil, keyboard: UIKeyboardType = .default) -> some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(Color("NiftyRed"))
            }
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .font(.system(size: 13))
                .foregroundColor(Color("NiftyRed"))
        }
        .padding(10)
        .background(Color(.white))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("NiftyGreen"), lineWidth: 2)
        )
    }

    private static func displayCondition(from condition: FindCondition) -> String {
        switch condition {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .needsRepair: return "Needs Repair"
        case .heavilyWorn: return "Heavily Worn"
        }
    }

    private func conditionValue(from displayString: String) -> FindCondition {
        switch displayString {
        case "Excellent": return .excellent
        case "Good": return .good
        case "Needs Repair": return .needsRepair
        case "Heavily Worn": return .heavilyWorn
        default: return .good
        }
    }

    private func saveChanges() {
        validationMessage = nil

        switch FindValidator.validate(
            name: findName,
            priceText: price,
            imageData: selectedImageData,
            existing: controller.finds,
            excludingID: find.id
        ) {
        case .failure(let error):
            validationMessage = error.errorDescription

        case .success(let priceValue):
            var updatedFind = find
            updatedFind.findName = findName.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedFind.price = priceValue
            updatedFind.storeName = storeFound.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedFind.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedFind.condition = conditionValue(from: condition)
            updatedFind.issues = issues.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedFind.repairNotes = repairNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedFind.personalNotes = personalNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedFind.image = selectedImageData

            // updateFind returns false (and shows an alert) if the database save failed.
            guard controller.updateFind(updatedFind) else { return }

            showSavedToast = true
            Task {
                try? await Task.sleep(nanoseconds: 1_200_000_000)
                onBack()
            }
        }
    }

    /// "Changes saved" message from the design.
    @ViewBuilder
    private var savedToast: some View {
        if showSavedToast {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color("NiftyYellow"))
                Text("Changes saved — looking nifty!")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color("NiftyRed").opacity(0.95))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            .padding(.bottom, 24)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    /// Loads the picked photo, shrinks it, and shows a message if anything goes wrong.
    @MainActor
    private func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }
        validationMessage = nil
        isLoadingPhoto = true
        defer { isLoadingPhoto = false }
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let optimized = ImageProcessor.optimizedJPEG(from: data) else {
                validationMessage = "That photo couldn't be used. Please try another one."
                return
            }
            selectedImageData = optimized
        } catch {
            validationMessage = "That photo couldn't be loaded. Please try another one."
        }
    }

}

#Preview {
    EditFindView(
        find: Find(
            findName: "Cherry red loafers",
            price: 46.00,
            storeName: "Vinted",
            brand: "Merry People",
            condition: .good,
            issues: "Light scuff on right toe; soles still have plenty of life.",
            repairNotes: "Try leather balm before first wear",
            personalNotes: "Would replace my worn everyday pair",
            status: .considering,
            image: nil
        ),
        onBack: {}
    )
    .environmentObject(FindController())
}
