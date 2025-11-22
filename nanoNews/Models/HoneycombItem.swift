//
//  HoneycombItem.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import Foundation

struct HoneycombItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String          // deactivated image
    let activatedImageName: String // activated image
    var category: String           // the news category
    var isActive: Bool = false     // activation state

    // Hashable is synthesized automatically
}
