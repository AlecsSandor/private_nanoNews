//
//  HoneycombMenuViewModel.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import SwiftUI

class HoneycombMenuViewModel: ObservableObject {
    @Published var items: [HoneycombItem]

    init(items: [HoneycombItem]) {
        self.items = items
    }

    func toggleItem(_ item: HoneycombItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isActive.toggle()

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
