//
//  HoneycombCellView.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import SwiftUI

struct HoneycombCellView: View {
    let item: HoneycombItem
    let size: CGFloat
    let scale: CGFloat
    let position: CGPoint
    let onTap: () -> Void
    let onLongPress: () -> Void

    @State private var pressScale: CGFloat = 1.0   // <-- temp scale for animation

    var body: some View {
        Image(item.isActive ? item.activatedImageName : item.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .scaleEffect(scale * pressScale)   // <-- apply elastic bump
            .opacity(scale)
            .position(position)
            .onTapGesture {
                onTap()
            }
            .onLongPressGesture(minimumDuration: 0.45) {
                
                // 1. Haptic feedback (heavy + crisp)
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)

                // 2. Elastic pop animation
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 6)) {
                    pressScale = 1.15   // pop up slightly
                }
                
                // 3. Return to normal
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 6)) {
                        pressScale = 1.0
                    }
                }

                // 4. Trigger your existing long-press action
                onLongPress()
            }
    }
}

