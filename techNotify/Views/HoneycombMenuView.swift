////
////  BubbleMenuItem.swift
////  techNotify
////
////  Created by Alex on 20/11/2025.
////
//
//
//import SwiftUI
//
///// MODEL
//struct HoneycombItem: Identifiable {
//    let id = UUID()
//    let imageName: String
//}
//
///// HONEYCOMB MENU VIEW — APPLE WATCH STYLE
//struct HoneycombMenuView: View {
//    let items: [HoneycombItem]
//
//    @GestureState private var drag: CGSize = .zero
//    @State private var offset: CGSize = .zero
//
//    // Grid spacing similar to Apple Watch honeycomb
//    let itemSize: CGFloat = 60
//    let spacing: CGFloat = 10
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                ForEach(Array(items.enumerated()), id: \.element.id) { i, item in
//                    let pos = honeycombPosition(index: i)
//                    let totalX = pos.x + offset.width + drag.width
//                    let totalY = pos.y + offset.height + drag.height
//
//                    let centerX = geo.size.width / 2
//                    let centerY = geo.size.height / 2
//
//                    let dx = totalX - centerX
//                    let dy = totalY - centerY
//                    let distance = sqrt(dx * dx + dy * dy)
//
//                    // Scale toward center
//                    let scale = max(0.25, 1.5 - distance / 300)
//
//                    // Fade farther away
//                    let opacity = max(0.15, 1.0 - distance / 250)
//
//                    Image(systemName: item.imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: itemSize, height: itemSize)
//                        .scaleEffect(scale)
//                        .opacity(opacity)
//                        .position(x: totalX, y: totalY)
//                        .animation(.easeOut(duration: 0.2), value: drag)
//                        .animation(.easeOut(duration: 0.2), value: offset)
//                }
//            }
//            .gesture(
//                DragGesture()
//                    .updating($drag) { value, state, _ in
//                        state = value.translation
//                    }
//                    .onEnded { value in
//                        offset.width += value.translation.width
//                        offset.height += value.translation.height
//                    }
//            )
//        }
//    }
//
//    // Calculates honeycomb-like coordinates
//    func honeycombPosition(index: Int) -> CGPoint {
//        let row = index / 8
//        let col = index % 8
//
//        let xOffset = (itemSize + spacing) * CGFloat(col)
//        let yOffset = (itemSize + spacing) * CGFloat(row)
//
//        // Offset every second row (hex grid)
//        let isOffset = row % 2 == 1
//        let x = xOffset + (isOffset ? (itemSize / 2) : 0) + 40
//        let y = yOffset + 40
//
//        return CGPoint(x: x, y: y)
//    }
//}
//
//struct HoneycombMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        HoneycombMenuView(items: [HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star"), HoneycombItem(imageName: "star")])
//    }
//}
//
//

//import SwiftUI
//
//struct HoneycombItem: Identifiable {
//    let id = UUID()
//    let imageName: String
//}
//
//struct HoneycombMenuView: View {
//    let items: [HoneycombItem]
//
//    @GestureState private var drag: CGSize = .zero
//    @State private var offset: CGSize = .zero
//
//    let itemSize: CGFloat = 90
//    let spacing: CGFloat = 50
//
//    var body: some View {
//        GeometryReader { geo in
//            let positions = hexSpiralPositions(
//                count: items.count,
//                cellSize: itemSize + spacing
//            )
//
//            let centerX = geo.size.width / 2
//            let centerY = geo.size.height / 2
//            let maxRadius = min(geo.size.width, geo.size.height) / 2
//            
//            ZStack {
//                ForEach(Array(items.enumerated()), id: \.element.id) { i, item in
//                    let pos = positions[i]
//
//                    let totalX = pos.x + offset.width + drag.width + centerX
//                    let totalY = pos.y + offset.height + drag.height + centerY
//
//                    let dx = totalX - centerX
//                    let dy = totalY - centerY
//                    let distance = sqrt(dx*dx + dy*dy)
//                    let normalized = min(1, distance / maxRadius)
//
//                    // 🔥 Smooth exponential scale falloff
//                    let scale = 0.2 + (1.3 - 0.2) * pow(1 - normalized, 2.6)
//
//                    // 🔥 Smooth opacity falloff
//                    let opacity = 0.15 + 0.85 * pow(1 - normalized, 2.0)
//
//                    Image(item.imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: itemSize, height: itemSize)
//                        .scaleEffect(scale)
//                        .opacity(opacity)
//                        .position(x: totalX, y: totalY)
//                        .animation(.easeOut(duration: 0.15), value: drag)
//                        .animation(.easeOut(duration: 0.15), value: offset)
//                }
//            }
//            
//            .gesture(
//                DragGesture()
//                    .updating($drag) { value, state, _ in
//                        state = value.translation
//                    }
//                    .onEnded { value in
//                        offset.width += value.translation.width
//                        offset.height += value.translation.height
//                    }
//            )
//        }
//    }
//}
//
//
//func hexSpiralPositions(count: Int, cellSize: CGFloat) -> [CGPoint] {
//    var axial: [(q: Int, r: Int)] = [(0, 0)]
//    if count == 1 { return [CGPoint.zero] }
//
//    var radius = 1
//    while axial.count < count {
//        var q = radius
//        var r = 0 - radius
//        let directions = [
//            (0, 1), (-1, 1), (-1, 0),
//            (0, -1), (1, -1), (1, 0)
//        ]
//        for dir in directions {
//            for _ in 0..<radius {
//                if axial.count >= count { break }
//                q += dir.0
//                r += dir.1
//                axial.append((q, r))
//            }
//        }
//        radius += 1
//    }
//
//    let w = cellSize
//    let h = cellSize * 0.866 // sin(60°)
//
//    return axial.map { (q, r) in
//        let x = w * (CGFloat(q) + CGFloat(r) / 2)
//        let y = h * CGFloat(r)
//        return CGPoint(x: x, y: y)
//    }
//}











import SwiftUI

// ---------------------------------------------------------
// MARK: - Data Model
// ---------------------------------------------------------

struct HoneycombItem: Identifiable {
    let id = UUID()
    let imageName: String
}

// ---------------------------------------------------------
// MARK: - Honeycomb Menu View
// ---------------------------------------------------------

struct HoneycombMenuView: View {
    let items: [HoneycombItem]

    // Drag state (temporary)
    @GestureState private var dragOffset: CGSize = .zero
    // Permanent accumulated offset from previous drags
    @State private var accumulatedOffset: CGSize = .zero
    
    // Grid layout
    let columns = 3
    let rows = 3

    // Magnification curve parameter (matches UIKit)
    let magnificationCurve: CGFloat = 30
    
    var body: some View {
        GeometryReader { geo in
            
            // Base cell size — matches original UICollectionViewLayout logic
            let cellSize = geo.size.width / 4.0
            
            // The ellipse radii used for magnification
            let ellipseRadiusX = 2.5 * geo.size.width
            let ellipseRadiusY = 2.5 * geo.size.height
            
            // Visual center of the screen
            let viewCenter = CGPoint(x: geo.size.width / 2,
                                     y: geo.size.height / 2)
            
            ZStack {
                ForEach(items.indices, id: \.self) { index in
                    
                    // Compute scaling, position shift, alpha, etc
                    let layout = computeHoneycombLayout(
                        index: index,
                        columns: columns,
                        cellSize: cellSize,
                        ellipseRadiusX: ellipseRadiusX,
                        ellipseRadiusY: ellipseRadiusY,
                        magnificationCurve: magnificationCurve,
                        viewCenter: viewCenter,
                        accumulatedOffset: accumulatedOffset,
                        dragOffset: dragOffset
                    )
                    
                    Image(items[index].imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: cellSize, height: cellSize)
                        .scaleEffect(layout.scale)
                        .opacity(layout.scale)   // identical to UIKit: alpha = z
                        .position(layout.position)
                        .animation(.easeOut(duration: 0.15), value: dragOffset)
                        .animation(.easeOut(duration: 0.15), value: accumulatedOffset)
                }
            }
            
            // ---------------------------------------------------------
            // MARK: Drag Handling
            // ---------------------------------------------------------
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        // Temporary drag translation while gesture is active
                        state = value.translation
                    }
                    .onEnded { value in
                        // Accumulate offset after gesture finishes
                        accumulatedOffset.width += value.translation.width
                        accumulatedOffset.height += value.translation.height
                    }
            )
            .background(Color("themeBlack"))
        }
    }
}

// ---------------------------------------------------------
// MARK: - Layout Calculator (UIKit-accurate)
// ---------------------------------------------------------

fileprivate func computeHoneycombLayout(
    index: Int,
    columns: Int,
    cellSize: CGFloat,
    ellipseRadiusX: CGFloat,
    ellipseRadiusY: CGFloat,
    magnificationCurve: CGFloat,
    viewCenter: CGPoint,
    accumulatedOffset: CGSize,
    dragOffset: CGSize
) -> (position: CGPoint, scale: CGFloat) {
    
    // ---------------------------------------------------------
    // MARK: 1. Compute Honeycomb Grid Position
    // ---------------------------------------------------------
    
    let col = index % columns
    let row = index / columns
    
    // Base grid coordinates
    var baseX = CGFloat(col) * cellSize
    var baseY = CGFloat(row) * cellSize
    
    // Offset every second row (the honeycomb staggering)
    if row.isMultiple(of: 2) == false {
        baseX += cellSize / 2
    }
    
    let originalX = baseX
    let originalY = baseY
    
    // ---------------------------------------------------------
    // MARK: 2. Add Gesture Offset (scrolling translation)
    // ---------------------------------------------------------
    
    let translatedX = baseX + accumulatedOffset.width + dragOffset.width
    let translatedY = baseY + accumulatedOffset.height + dragOffset.height
    
    // Position relative to the screen center
    let relativeX = translatedX - viewCenter.x
    let relativeY = translatedY - viewCenter.y
    
    // ---------------------------------------------------------
    // MARK: 3. Elliptical Magnification (matches UIKit)
    // ---------------------------------------------------------
    
    // Project relative position onto an ellipse
    let ellipseTermX = -(relativeX * relativeX) / (ellipseRadiusX * ellipseRadiusX)
    let ellipseTermY = -(relativeY * relativeY) / (ellipseRadiusY * ellipseRadiusY)
    
    // Scale factor (z) and raw shift driver (zz)
    var scaleZ = magnificationCurve * (ellipseTermX + ellipseTermY) + 1.0
    var shiftFactorZZ = magnificationCurve * (ellipseTermX + ellipseTermY)
    
    // UIKit clamping rules:
    if scaleZ < 0 { scaleZ = 0 }
    if scaleZ < 0.2 && scaleZ > 0 { scaleZ = 0.2 }  // minimum visible scale
    if shiftFactorZZ > 0 { shiftFactorZZ = 0 }      // only negative values matter
    
    // ---------------------------------------------------------
    // MARK: 4. Compute "Pull Toward Center" Offset
    // ---------------------------------------------------------
    
    // UIKit logic:
    // newCenter = origin + (origin - cellCenter) * (-zz / 4)
    
    let shiftedX =
        (viewCenter.x - originalX) * (-shiftFactorZZ / 4.0)
        + originalX
        + accumulatedOffset.width
        + dragOffset.width
    
    let shiftedY =
        (viewCenter.y - originalY) * (-shiftFactorZZ / 4.0)
        + originalY
        + accumulatedOffset.height
        + dragOffset.height

    return (CGPoint(x: shiftedX, y: shiftedY), scaleZ)
}



struct HoneycombMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HoneycombMenuView(items: [HoneycombItem(imageName: "_01"), HoneycombItem(imageName: "_02"), HoneycombItem(imageName: "_03"), HoneycombItem(imageName: "_04"), HoneycombItem(imageName: "_05"), HoneycombItem(imageName: "_06"), HoneycombItem(imageName: "_07"), HoneycombItem(imageName: "_08"), HoneycombItem(imageName: "_09"), HoneycombItem(imageName: "_10"), HoneycombItem(imageName: "_03")])
    }
}
