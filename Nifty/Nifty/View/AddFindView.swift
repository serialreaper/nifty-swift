//
//  AddFindView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/11/26.
//

import SwiftUI
import PhotosUI

struct AddFindView: View {
    @EnvironmentObject var controller: FindController
    var onBack: () -> Void

    @State private var findName = ""
    @State private var price = ""
    @State private var storeFound = ""
    @State private var brand = ""
    @State private var condition = "Good"
    @State private var issues = ""
    @State private var repairNotes = ""
    @State private var personalNotes = ""

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?

    @State private var validationMessage: String?
    @State private var isLoadingPhoto = false
    @State private var showDiscardConfirm = false
    @State private var showSavedConfirm = false

    private let conditions = ["Excellent", "Good", "Needs Repair", "Heavily Worn"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    
                    if let validationMessage {
                        Text("* \(validationMessage)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("NiftyRed"))
                    }

                    // PHOTO PICKER
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 92)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("NiftyGreen"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 92)
                                .overlay {
                                    VStack(spacing: 4) {
                                        Image(systemName: "camera")
                                            .foregroundColor(Color("NiftyRed"))
                                        Text("Add a photo*")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(Color("NiftyRed"))
                                    }
                                }
                        }
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
                                            lineWidth: 2
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

                    // REPAIR NOTES & PERSONAL NOTES ROW
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("REPAIR NOTES")
                            customTextField(text: $repairNotes, placeholder: "Try leather balm")
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("PERSONAL NOTES")
                            customTextField(text: $personalNotes, placeholder: "Would replace my old pair")
                        }
                    }

                    // SAVE FIND BUTTON
                    Button {
                        save()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                            Text("Save Find")
                        }
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("NiftyRed"))
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)

                }
                .padding()
            }
            .navigationTitle("Add Find")
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
            .alert("Your find has been saved.", isPresented: $showSavedConfirm) {
                Button("Okay") {
                    resetForm()
                    onBack()
                }
            }
        }
        .overlay {
            if showDiscardConfirm {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showDiscardConfirm = false }

                    CustomDialogBox(
                        mascot: .toss,
                        title: "Toss this draft?",
                        message: "Your notes and photo won't be saved. You can keep editing instead.",
                        primaryButtonTitle: "Discard Find",
                        secondaryButtonTitle: "Keep Editing",
                        primaryAction: {
                            showDiscardConfirm = false
                            resetForm()
                            onBack()
                        },
                        secondaryAction: {
                            showDiscardConfirm = false
                        }
                    )
                    .padding(.horizontal, 24)
                }
            }
        }
    }

    private var hasUnsavedChanges: Bool {
        !findName.isEmpty || !price.isEmpty || !storeFound.isEmpty || !brand.isEmpty ||
        !issues.isEmpty || !repairNotes.isEmpty || !personalNotes.isEmpty || selectedImageData != nil
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

    private func conditionValue(from displayString: String) -> FindCondition {
        switch displayString {
        case "Excellent": return .excellent
        case "Good": return .good
        case "Needs Repair": return .needsRepair
        case "Heavily Worn": return .heavilyWorn
        default: return .excellent
        }
    }

    private func save() {
        validationMessage = nil

        switch FindValidator.validate(
            name: findName,
            priceText: price,
            imageData: selectedImageData,
            existing: controller.finds
        ) {
        case .failure(let error):
            validationMessage = error.errorDescription

        case .success(let priceValue):
            let newFind = Find(
                findName: findName.trimmingCharacters(in: .whitespacesAndNewlines),
                price: priceValue,
                storeName: storeFound.trimmingCharacters(in: .whitespacesAndNewlines),
                brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
                condition: conditionValue(from: condition),
                issues: issues.trimmingCharacters(in: .whitespacesAndNewlines),
                repairNotes: repairNotes.trimmingCharacters(in: .whitespacesAndNewlines),
                personalNotes: personalNotes.trimmingCharacters(in: .whitespacesAndNewlines),
                status: .considering,
                image: selectedImageData
            )

            // addFind returns false (and shows an alert) if the database save failed.
            if controller.addFind(newFind) {
                showSavedConfirm = true
            }
        }
    }

    /// Clears the form so the next visit to this tab starts fresh.
    private func resetForm() {
        findName = ""
        price = ""
        storeFound = ""
        brand = ""
        condition = "Good"
        issues = ""
        repairNotes = ""
        personalNotes = ""
        selectedPhoto = nil
        selectedImageData = nil
        validationMessage = nil
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
    AddFindView(onBack: {})
        .environmentObject(FindController())
}
