//
//  ObjectOVModifier.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI

struct ObjectOVModifier: ViewModifier {
    @State var rectPosition: CGPoint
    @GestureState var isDragging: Bool
    @State var geometry: GeometryProxy
    @Binding var showInspector: Bool
    @Binding var selected: DSPObject
    @State var dspObject: DSPObject
    @State var objectMTG: ObjectManager
    
    func body(content: Content) -> some View {
        GeometryReader { geom in
            content
                
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(getColorName(dspObject)), lineWidth: 6).opacity(selected.id == dspObject.id ? 1 : 0))
                .onAppear {
                    rectPosition = objectMTG.getObject(id: dspObject.id)!.currentPosition
                }
                .position(rectPosition)
                .gesture(DragGesture().onChanged({ value in
                    withAnimation {
                        if (value.location.x >= 60 && value.location.x <= geometry.size.width-65) && (value.location.y >= 35 && value.location.y <= geometry.size.height-50) {
                            self.rectPosition = CGPoint(x: value.location.x, y: value.location.y)
                            
                        }
                    }
                    
                    
                })
                .onEnded({ value in
                    objectMTG.updatePosition(dspObject: dspObject, to: value.location)
                })
                .updating($isDragging, body: { (value, state, trans) in
                    state = true
                }))
                .onTapGesture {
                    withAnimation {
                        showInspector = true
                        selected = objectMTG.getObject(id: dspObject.id)!
                    }
                }
                
        }
            
    }
    
    private func getColorName(_ dspObj: DSPObject) -> String {
        switch dspObj.type {
        case .audioFile:
            return "AudioFileText"
        case .filter:
            return "FilterText"
        case .outputDevice:
            return "OutputDeviceText"
        }
    }
}
