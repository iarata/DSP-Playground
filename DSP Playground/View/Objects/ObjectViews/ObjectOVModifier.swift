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
    @State var clickLocatin: NSPoint
    @State var geometry: GeometryProxy
    
    @State var objDetails: DSPObject
    
    @Binding var objectNewName: String
    @Binding var showDetails: Bool
    @Binding var isEditing: Bool
    
    @State var dspObject: DSPObject
    
    func body(content: Content) -> some View {
        GeometryReader { geom in
            content
                .onAppear {
                    rectPosition = ObjectManager().getObject(id: dspObject.id)!.currentPosition
                }
                .position(rectPosition)
                .gesture(DragGesture().onChanged({ value in
                    withAnimation {
                        if (value.location.x >= 60 && value.location.x <= geometry.size.width-65) && (value.location.y >= 35 && value.location.y <= geometry.size.height-120) {
                            self.rectPosition = CGPoint(x: value.location.x, y: value.location.y)
                            
                        }
                    }
                    
                    
                })
                .onEnded({ value in
                    ObjectManager().updatePosition(dspObject: dspObject, to: value.location)
                })
                .updating($isDragging, body: { (value, state, trans) in
                    state = true
                }))
        }
            
    }
}
