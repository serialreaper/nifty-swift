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
    @State private var condition = "Excellent"
    @State private var issues = ""
    @State private var repairNotes = ""
    @State private var personalNotes = ""
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    @State private var showValidationError = false
    @State private var showDiscardConfirm = false
    @State private var showSavedConfirm = false
    
    private let conditions = ["Excellent", "Good", "Needs Repair", "Heavily Worn"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    if showValidationError {
                        Text("* Complete the required fields to save this find.")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("NiftyRed"))
                    }
                    
                    // PHOTO
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PHOTO*")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            if let selectedImageData,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray6))
                                    .frame(width: 64, height: 64)
                                    .overlay(Image(systemName: "plus").foregroundColor(.gray))
                            }
                        }
                        .onChange(of: selectedPhoto) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    }
                    
                    // ITEM NAME
                    fieldLabel("ITEM NAME", required: true)
                    TextField("", text: $findName)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    // PRICE + STORE
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("PRICE", required: true)
                            TextField("", text: $price)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("STORE/WHERE FOUND")
                            TextField("", text: $storeFound)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    
                    // BRAND
                    fieldLabel("BRAND")
                    TextField("", text: $brand)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    // CONDITION TAGS
                    fieldLabel("CONDITION", required: true)
                    HStack(spacing: 8) {
                        ForEach(conditions, id: \.self) { option in
                            Text(option)
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(condition == option ? Color("NiftyGreen") : Color(.systemGray6))
                                .foregroundColor(condition == option ? .white : .black)
                                .cornerRadius(8)
                                .onTapGesture {
                                    condition = option
                                }
                        }
                    }
                    
                    // ISSUES
                    fieldLabel("ISSUES")
                    TextField("", text: $issues)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    // REPAIR NOTES
                    fieldLabel("REPAIR NOTES")
                    TextField("", text: $repairNotes)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    // PERSONAL NOTES
                    fieldLabel("PERSONAL NOTES")
                    TextField("", text: $personalNotes)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Add New Find")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if hasUnsavedChanges {
                            showDiscardConfirm = true
                        } else {
                            onBack()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .foregroundColor(Color("NiftyRed"))
                    .fontWeight(.semibold)
                }
            }
            .alert("Discard this find?", isPresented: $showDiscardConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Discard", role: .destructive) { onBack() }
            } message: {
                Text("Your changes haven't been saved. If you leave now, this find will be lost.")
            }
            .alert("Your find has been saved.", isPresented: $showSavedConfirm) {
                Button("Okay") { onBack() }
            }
        }
    }
    
    private var hasUnsavedChanges: Bool {
        !findName.isEmpty || !price.isEmpty || !storeFound.isEmpty || !brand.isEmpty
    }
    
    private func fieldLabel(_ text: String, required: Bool = false) -> some View {
        Text(required ? "\(text)*" : text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.secondary)
    }
    
    /// Converts the display-friendly condition string ("Needs Repair") into
    /// the matching FindCondition enum case (.needsRepair) used by the model.
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
        // ITEM NAME and PRICE are required (marked * in the Figma form).
        // PRICE must also successfully convert from the text field's String to a Double.
        guard !findName.trimmingCharacters(in: .whitespaces).isEmpty,
              let priceValue = Double(price) else {
            showValidationError = true
            return
        }
        showValidationError = false
        
        let newFind = Find(
            findName: findName,
            price: priceValue,
            storeName: storeFound,
            brand: brand,
            condition: conditionValue(from: condition),
            issues: issues,
            repairNotes: repairNotes,
            personalNotes: personalNotes,
            status: .considering,
            image: selectedImageData
        )
        controller.addFind(newFind)
        showSavedConfirm = true
    }
}

#Preview {
    AddFindView(onBack: {})
        .environmentObject(FindController())
}
