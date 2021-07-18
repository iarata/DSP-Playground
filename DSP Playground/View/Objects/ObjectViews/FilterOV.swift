//
//  FilterOV.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI

struct FilterOV: View {
    
    @ObservedObject var objectManager = ObjectManager()
    
    @State var dspObject: DSPObject
    @Binding var isEditing: Bool
    @Binding var newItemName: String
    @State var position: CGPoint
    
    @State private var isHoveringMain = false
    @State private var isHoveringCircle = false
    
    @State var connectionMG: ConnectionManager
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(isHoveringMain ? Color.white : Color.white.opacity(0.5))
                .onHover(perform: { isHovering in
                    withAnimation {
                        self.isHoveringMain = isHovering
                    }
                })
                .shadow(radius: 5)
                .offset(y: -25)
                .zIndex(99)
                .onTapGesture {
                    if connectionMG.connecting {
                        print(connectionMG.publicConnection)
                        connectionMG.initStop(stop: dspObject.id)
                        print(connectionMG.publicConnection)
                    }
                }

            HStack {
                Image(systemName: dspObject.type.rawValue).foregroundColor(Color("FilterText")).font(.system(size: 20))
                if isEditing {
                    TextField(dspObject.title ?? "Rename this", text: $newItemName, onCommit: {
                        self.isEditing.toggle()
                        self.objectManager.updateName(of: dspObject.id, to: newItemName, position: position)
                        self.newItemName = ""
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                    .zIndex(999)
                    .frame(width: 60)
                } else {
                    VStack(alignment: .leading) {
                        Text(dspObject.title ?? "Rename this").bold().foregroundColor(Color("FilterText"))
                        Text("\(dspObject.id)").font(.footnote).opacity(0.4)
                    }
                }
                
            }.padding(10)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color("Filter").opacity(0.2)))
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(isHoveringCircle ? Color.white : Color.white.opacity(0.5))
                .onHover(perform: { isHovering in
                    withAnimation {
                        self.isHoveringCircle = isHovering
                    }
                })
                .shadow(radius: 5)
                .offset(y: 25)
        }
    }
}
