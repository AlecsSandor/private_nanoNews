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
        ZStack(alignment: .top) {
//            Color("themeBlack").ignoresSafeArea()
            
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
                .background(Color("themeBlack"))
                .onAppear {
                    vm.notifications.forEach { news in
                        print("News title: \(news.title)")
                    }
                }
            }
            
            // TOP FADE
                    VStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color("themeBlack"),
                                Color.black.opacity(0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)      // increased height for better fade
                        .allowsHitTesting(false) // important so scroll still works

                        Spacer()
                    }
//                    .ignoresSafeArea()
                    
                    // BOTTOM FADE
                    VStack {
                        Spacer()
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0),
                                Color("themeBlack")
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)      // increased height for better fade
                        .allowsHitTesting(false) // important
                    }
                    .ignoresSafeArea()
            
//            // TOP GLASS FADE
//                    VStack {
//                        BlurFade(height: 120, isTop: true)
//                            .allowsHitTesting(false)
//                        Spacer()
//                    }
//
//                    // BOTTOM GLASS FADE
//                    VStack {
//                        Spacer()
//                        BlurFade(height: 120, isTop: false)
//                            .allowsHitTesting(false)
//                    }
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

struct BlurFade: View {
    let height: CGFloat
    let isTop: Bool

    var body: some View {
        Rectangle()
            .fill(.ultraThinMaterial)  // blur glass layer
            .overlay(
                LinearGradient(
                    colors: isTop
                        ? [Color.black.opacity(0.35), Color.black.opacity(0.0)]
                        : [Color.black.opacity(0.0), Color.black.opacity(0.35)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .blur(radius: 6)   // softens the edges for a true glass feel
            .frame(height: height)
    }
}
