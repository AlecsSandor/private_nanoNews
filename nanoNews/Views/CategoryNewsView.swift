//
//  CategoryNewsView.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import SwiftUI

struct CategoryNewsView: View {
    
    //    let category: String
    @StateObject private var vm: CategoryNewsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(category: String, useDummyData: Bool = true) {
        _vm = StateObject(wrappedValue: CategoryNewsViewModel(category: category, useDummyData: useDummyData))
    }
    
    var body: some View {
        ZStack {
            Color("themeBlack").ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView("Loading…")
            } else if let error = vm.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(vm.notifications) { news in
                            NewsItemView(news: news)
                        }
                    }
                    .padding(.vertical)
                }
                .onAppear {
                    vm.notifications.forEach { news in
                        print("News title: \(news.title)")
                    }
                }
            }
        }
        //        .navigationTitle(category.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Dismiss view
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                VStack(spacing: 10) {
                    Button(action: {
                        //                        isPresentingNewView = true
                    })
                    {
                        Image("_05")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }
                //                .sheet(isPresented: $isPresentingNewView) {
                //                    SavedSnippetsView(language: language ?? "Coding", isPresentingNewView: $isPresentingNewView)
                //                }
            }
            
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Fashion")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color("themeBlack"), for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        
    }
}

