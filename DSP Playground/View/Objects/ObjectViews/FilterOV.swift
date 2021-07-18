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
    
    var body: some View {
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
        
        
    }
}
