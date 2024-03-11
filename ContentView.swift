//
//  ContentView.swift
//  sniper
//
//  Created by 塗國豪 on 2023/11/27.
//

import SwiftUI

struct ContentView: View {
    @State private var isNightVisin = true
    
    var body: some View {
        ZStack(alignment: .bottom){
            ZStack{
                Rectangle().fill(isNightVisin ? .black : .white)
                
                Text("😱").font(.system(size: 100))
                    .offset(x: 0, y: 20)
                    .scaleEffect(zoomScale)
                    .rotationEffect(Angle(degrees: 30))
                    
                
                SniperscopeView(nightVision: isNightVisin)
                    .offset(panOffset)
                    .scaleEffect(zoomScale)
                    .padding()
                    .onTapGesture {
                        isNightVisin.toggle()
                    }
            }
            Text("zoomScale: \(String(format: "%.2f", zoomScale))")
                .foregroundColor(isNightVisin ? .white : .black)
                .font(.title)
        }
        .ignoresSafeArea()
        .onLongPressGesture {
            steadyStateZoomScale = 3.0
        }
        .gesture(pinch.simultaneously(with: pan))
        
    }
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState var gesturePanOffset: CGSize = .zero
    private var panOffset: CGSize{
        steadyStatePanOffset + gesturePanOffset
    }
    
    private var pan: some Gesture{
        DragGesture()
            .updating($gesturePanOffset, body: { latestGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestGestureValue.translation
            })
            .onEnded { finalGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + finalGestureValue.translation
            }
    }
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState var gestureZoomScale: CGFloat = 1.0
    private var zoomScale: CGFloat{
        steadyStateZoomScale * gestureZoomScale
    }
    
    private var pinch: some Gesture{
        return MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureZoomScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureZoomScale
            }
            .onEnded { finalGestureZoomScale in
                steadyStateZoomScale *= finalGestureZoomScale
            }
    }
}

extension CGSize{
    static func +(lhs: Self, rhs: Self) -> CGSize{
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

