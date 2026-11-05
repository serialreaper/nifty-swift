//
//  FindsListView.swift
//  Nifty
//
//  Created by Mac-LAB on 9/11/26.
//

import SwiftUI

// FindsListView.swift
struct FindsListView: View {
    @EnvironmentObject var controller: FindController

    @State private var selectedFilter: FindFilter = .all
    @State private var isSearching = false
    @State private var searchText = ""
    @FocusState private var searchFocused: Bool

    private var trimmedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Finds for the selected tab, narrowed by the search text (name, brand or store).
    private var visibleFinds: [Find] {
        let base = controller.finds(for: selectedFilter)
        guard !trimmedQuery.isEmpty else { return base }
        return base.filter {
            $0.findName.localizedCaseInsensitiveContains(trimmedQuery)
            || $0.brand.localizedCaseInsensitiveContains(trimmedQuery)
            || $0.storeName.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // HEADER + SEARCH BUTTON
                    HStack {
                        Text("Your finds")
                            .font(.calSans(size: 32))
                            .foregroundStyle(Color("NiftyRed"))
                        Spacer()
                        Button {
                            toggleSearch()
                        } label: {
                            Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color("NiftyRed"))
                                .frame(width: 36, height: 36)
                                .background(Color("NiftyGreen"))
                                .cornerRadius(10)
                        }
                        .accessibilityLabel(isSearching ? "Close search" : "Search finds")
                    }

                    if isSearching {
                        searchField
                    }

                    filterPill

                    // LIST OR EMPTY STATE
                    if visibleFinds.isEmpty {
                        emptyState
                            .padding(.top, 40)
                    } else {
                        VStack(spacing: 20) {
                            ForEach(visibleFinds) { find in
                                NavigationLink(value: find.id) {
                                    FindCard(
                                        image: find.image,
                                        findName: find.findName,
                                        price: Currency.string(find.price),
                                        condition: find.condition.displayName,
                                        status: find.status.displayName
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: UUID.self) { id in
                if let find = controller.find(id: id) {
                    FindDetailScreen(find: find)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Pieces

    private var filterPill: some View {
        HStack(spacing: 0) {
            ForEach(FindFilter.allCases, id: \.self) { filter in
                Button {
                    selectedFilter = filter
                } label: {
                    Text(filter.rawValue)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color("NiftyRed"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selectedFilter == filter ? Color.white : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selectedFilter == filter ? .isSelected : [])
            }
        }
        .padding(4)
        .background(Color("NiftyGreen"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var searchField: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundColor(Color("NiftyRed"))
            TextField("Search name, brand or store", text: $searchText)
                .focused($searchFocused)
                .font(.system(size: 13))
                .foregroundColor(Color("NiftyRed"))
                .submitLabel(.search)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("NiftyGreen"), lineWidth: 2)
        )
    }

    @ViewBuilder
    private var emptyState: some View {
        if !trimmedQuery.isEmpty {
            MascotEmptyState(
                label: "MASCOT — NO RESULTS",
                title: "No matches",
                message: "Nothing matches “\(trimmedQuery)”. Try another name, brand or store."
            )
        } else {
            switch selectedFilter {
            case .all:
                MascotEmptyState(
                    label: "MASCOT — ALL EMPTY",
                    title: "No finds yet",
                    message: "Tap + to add something tempting and give it a little breathing room."
                )
            case .considering:
                MascotEmptyState(
                    label: "MASCOT — CONSIDERING EMPTY",
                    title: "Your pause zone is clear",
                    message: "New maybes will wait here while you decide without the rush."
                )
            case .bought:
                MascotEmptyState(
                    label: "MASCOT — BOUGHT EMPTY",
                    title: "No buys yet",
                    message: "When a considered find earns a yes, it will live here."
                )
            case .passed:
                MascotEmptyState(
                    label: "MASCOT — PASSED EMPTY",
                    title: "Your savings story starts here",
                    message: "Every thoughtful pass becomes a tiny win worth celebrating."
                )
            }
        }
    }

    private func toggleSearch() {
        isSearching.toggle()
        if isSearching {
            searchFocused = true
        } else {
            searchText = ""
            searchFocused = false
        }
    }
}

#Preview {
    FindsListView()
        .environmentObject(FindController())
}
