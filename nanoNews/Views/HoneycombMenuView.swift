//
//  BubbleMenuItem.swift
//  techNotify
//
//  Created by Alex on 20/11/2025.
//

import SwiftUI
import AudioToolbox

// ---------------------------------------------------------
// MARK: - Honeycomb Menu View
// ---------------------------------------------------------

struct HoneycombMenuView: View {
    
    @ObservedObject var viewModel: HoneycombMenuViewModel
    var onCategoryLongPressed: (HoneycombItem) -> Void
    // Drag state (temporary)
    @GestureState private var dragOffset: CGSize = .zero
    // Permanent accumulated offset from previous drags
    @State private var accumulatedOffset: CGSize = .zero
    
    // Grid layout
    let columns = 4
    let rows = 4
    
    // Magnification curve parameter (matches UIKit)
    let magnificationCurve: CGFloat = 30
    
    // Adding State for Stepping
    @State private var lastStepOffset: CGSize = .zero
    let stepSize: CGFloat = 40    // step threshold in points
    
    var body: some View {
        GeometryReader { geo in
            
            // Base cell size — matches original UICollectionViewLayout logic
            let cellSize = geo.size.width / 3.0
            
            // The ellipse radii used for magnification
            let ellipseRadiusX = 2.5 * geo.size.width
            let ellipseRadiusY = 2.5 * geo.size.height
            
            // Visual center of the screen
            let viewCenter = CGPoint(x: geo.size.width / 2,
                                     y: geo.size.height / 2)
            
            ZStack {
                ForEach(viewModel.items.indices, id: \.self) { index in
                    
                    let item = viewModel.items[index]
                    
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
                    
                    HoneycombCellView(
                        item: viewModel.items[index],
                        size: cellSize,
                        scale: layout.scale,
                        position: layout.position,
                        onTap: {
                            onCategoryLongPressed(item)
                        },
                        onLongPress: {
                            viewModel.toggleItem(item)
                        }
                    )
                }
            }
            .animation(.easeOut(duration: 0.15), value: dragOffset)
            .animation(.easeOut(duration: 0.15), value: accumulatedOffset)
            
            // ---------------------------------------------------------
            // MARK: Drag Handling
            // ---------------------------------------------------------
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        // Temporary drag translation
                        state = value.translation

                        // Trigger step feedback on the fly
                        handleStepFeedback(for: value.translation)
                    }
                    .onEnded { value in
                        // Snap to nearest step
                        let stepX = round(value.translation.width / stepSize) * stepSize
                        let stepY = round(value.translation.height / stepSize) * stepSize

                        accumulatedOffset.width += stepX
                        accumulatedOffset.height += stepY

                        // Reset step base
                        lastStepOffset = .zero
                    }
            )
            .background(Color("themeBlack"))
        }
    }
    
    private func handleStepFeedback(for newOffset: CGSize) {
        let dx = newOffset.width - lastStepOffset.width
        let dy = newOffset.height - lastStepOffset.height

        // If movement passes threshold → trigger a step
        if abs(dx) > stepSize || abs(dy) > stepSize {

            // Medium haptic
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()

            // Optional: Picker “click” sound
            AudioServicesPlaySystemSound(1104) // same sound used by picker

            // Reset step marker
            lastStepOffset = newOffset
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

//struct HoneycombMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        HoneycombMenuView(items: [HoneycombItem(imageName: "_01"), HoneycombItem(imageName: "_02"), HoneycombItem(imageName: "_03"), HoneycombItem(imageName: "_04"), HoneycombItem(imageName: "_05"), HoneycombItem(imageName: "_06"), HoneycombItem(imageName: "_07"), HoneycombItem(imageName: "_08"), HoneycombItem(imageName: "_09"), HoneycombItem(imageName: "_10"), HoneycombItem(imageName: "_03")])
//    }
//}
