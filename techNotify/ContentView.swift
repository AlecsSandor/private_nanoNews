//
//  ContentView.swift
//  techNotify
//
//  Created by Alex on 20/11/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HoneycombMenuView(items: [
                HoneycombItem(imageName: "_01"), HoneycombItem(imageName: "_02"), HoneycombItem(imageName: "_03"), HoneycombItem(imageName: "_04"), HoneycombItem(imageName: "_05"), HoneycombItem(imageName: "_06"), HoneycombItem(imageName: "_07"), HoneycombItem(imageName: "_08"), HoneycombItem(imageName: "_09"), HoneycombItem(imageName: "_10"), HoneycombItem(imageName: "_03"),HoneycombItem(imageName: "_01"), HoneycombItem(imageName: "_02"), HoneycombItem(imageName: "_03"), HoneycombItem(imageName: "_04"), HoneycombItem(imageName: "_05"), HoneycombItem(imageName: "_06"), HoneycombItem(imageName: "_07"), HoneycombItem(imageName: "_08"), HoneycombItem(imageName: "_09"), HoneycombItem(imageName: "_10"), HoneycombItem(imageName: "_03")
            ])
        }
        .padding(0)
    }
}

#Preview {
    ContentView()
}
