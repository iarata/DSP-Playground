//
//  Objects.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import SwiftUI

struct Objects: View {
    
    @Binding var showSheet: Bool
    
    @State  var hovered = false
    var objectsTypeList: [ObjectType] = [.audioFile, .filter, .outputDevice]
    @State  var selection: ObjectType?
    
    @ObservedObject var objectManager = ObjectManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Nodes").font(.system(size: 18)).bold()
                    Text("Start by choosing the audio file node.").font(.footnote)
                }.padding([.horizontal, .top])
                Spacer()
                Button {
                    withAnimation {
                        self.showSheet.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundColor(Color.gray.opacity(hovered ? 1.0 : 0.5))
                }
                .onHover { isHovered in
                    withAnimation {
                        self.hovered = isHovered
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()
                
                
                
            }
            List(objectsTypeList, id: \.self, selection: $selection) { object in
                ObjectItem(typeOfItem: object).tag(object)
            }.listStyle(PlainListStyle())
            Divider()
            HStack {
                Spacer()
                Button("Cancel") {
                    self.showSheet.toggle()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Add") {
                    if let selectedObj = selection {
                        objectManager.saveObject(DSPObject(id: UUID(), type: selectedObj, title: nil, currentPosition: CGPoint(x: 148, y: 43), path: nil))
                        DSPNotification().update(object: self)
                    }
                    self.showSheet.toggle()
                }
                .disabled(selection == nil || (!objectManager.isAudioFileExist() && selection != .audioFile))
                .keyboardShortcut(.defaultAction)
                
            }.padding([.horizontal, .bottom]).padding(.top, 2)
            
        }
        
        .frame(width: 300, height: 280)
    }
}
