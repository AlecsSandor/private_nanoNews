//
//  ContentView.swift
//  techNotify
//
//  Created by Alex on 20/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = HoneycombMenuViewModel(items: [
        HoneycombItem(imageName: "AI",         activatedImageName: "AI_On",         category: "artificial_intelligence"),
        HoneycombItem(imageName: "Sports",     activatedImageName: "Sports_On",     category: "nanotechnology"),
        HoneycombItem(imageName: "Fashion",    activatedImageName: "Fashion_On",    category: "blockchain"),
        HoneycombItem(imageName: "Health",     activatedImageName: "Health_On",     category: "fashion-tech"),
        HoneycombItem(imageName: "Climate",    activatedImageName: "Climate_On",    category: "space-tech"),
        HoneycombItem(imageName: "Crypto",     activatedImageName: "Crypto_On",     category: "artificial_intelligence"),
        HoneycombItem(imageName: "Culture",    activatedImageName: "Culture_On",    category: "nanotechnology"),
        HoneycombItem(imageName: "Energy",     activatedImageName: "Energy_On",     category: "blockchain"),
        HoneycombItem(imageName: "Food",       activatedImageName: "Food_On",       category: "fashion-tech"),
        HoneycombItem(imageName: "Politics",   activatedImageName: "Politics_On",   category: "space-tech"),
        HoneycombItem(imageName: "Defense",    activatedImageName: "Defense_On",    category: "artificial_intelligence"),
        HoneycombItem(imageName: "BioTech",    activatedImageName: "BioTech_On",    category: "nanotechnology"),
        HoneycombItem(imageName: "Economy",    activatedImageName: "Economy_On",    category: "blockchain"),
        HoneycombItem(imageName: "Finance",    activatedImageName: "Finance_On",    category: "fashion-tech"),
        HoneycombItem(imageName: "Gaming",     activatedImageName: "Gaming_On",     category: "space-tech"),
        HoneycombItem(imageName: "Markets",    activatedImageName: "Markets_On",    category: "artificial_intelligence"),
        HoneycombItem(imageName: "Movies",     activatedImageName: "Movies_On",     category: "nanotechnology"),
        HoneycombItem(imageName: "Politics",   activatedImageName: "Politics_On",   category: "blockchain"),     // duplicate name, but OK
        HoneycombItem(imageName: "RealEstate", activatedImageName: "RealEstate_On", category: "fashion-tech"),
        HoneycombItem(imageName: "Science",    activatedImageName: "Science_On",    category: "space-tech"),
        HoneycombItem(imageName: "Space",      activatedImageName: "Space_On",      category: "nanotechnology"),
        HoneycombItem(imageName: "Sports",     activatedImageName: "Sports_On",     category: "blockchain"),     // duplicate name, but OK
        HoneycombItem(imageName: "Startups",   activatedImageName: "Startups_On",   category: "fashion-tech"),
        HoneycombItem(imageName: "Tech",       activatedImageName: "Tech_On",       category: "space-tech"),
        HoneycombItem(imageName: "Travel",     activatedImageName: "Travel_On",     category: "space-tech")
    ])
    
    @State private var selectedCategory: HoneycombItem?
    @State private var showInstruction = false
    @State private var hasShownInstruction = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                    
                    HoneycombMenuView(
                        viewModel: vm,
                        onCategoryLongPressed: { item in
                            print("Selected category: \(item.category)")
                            selectedCategory = item
                        }
                    )
                    .navigationDestination(item: $selectedCategory) { item in
                        CategoryNewsView(category: item.category)
                    }

                    // -----------------------------------------------------
                    // MARK: Instruction Banner Overlay
                    // -----------------------------------------------------
                    if showInstruction {
                        instructionBanner
                            .transition(
                                .move(edge: .top)
                                .combined(with: .opacity)
                            )
                            .zIndex(10)
                    }
                }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Nano News")
                            .font(.headline)
                        //.font(Font.custom("Montserrat Alternates", size: 15, relativeTo: .body))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    VStack(spacing: 10) {
                        Button(action: {
                            //                        isPresentingNewView = true
                        })
                        {
                            Image(systemName: "gear")
                                .symbolVariant(.fill)
                                .font(.system(size: 16))
                                .foregroundColor(Color.white)
                                .padding(.vertical, 10)
                        }
                        //                    .sheet(isPresented: $isPresentingNewView) {
                        //                        InstructionsView(isPresentingNewView: $isPresentingNewView)
                        //                    }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Button(action: {
                        })
                        {
                            Image("appIcon")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                    }
                }
            }
            .toolbarBackground(Color("themeBlack"), for: .navigationBar)
        }
        .onAppear {
            if !hasShownInstruction {
                hasShownInstruction = true
                
                // Delay slightly so layout is ready
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showInstruction = true
                    }
                }
                
                // Hide after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showInstruction = false
                    }
                }
            }
        }
    }
}


extension ContentView {

    var instructionBanner: some View {
        VStack {
            // Top spacing so it doesn't touch the notch
            Spacer().frame(height: 40)
            
            HStack {
                Text("Tap & Hold to activate notifications for a category")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.2))
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)

            Spacer() // pushes banner to upper part of screen
        }
        .transition(.opacity)
    }
}


#Preview {
    ContentView()
}
