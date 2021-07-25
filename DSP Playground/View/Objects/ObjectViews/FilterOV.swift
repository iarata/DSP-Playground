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
    @State var position: CGPoint
    
    @State var pub = DSPNotification().publisher()
    
    @State var connectionMG: ConnectionManager
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: dspObject.type.rawValue).foregroundColor(Color("FilterText")).font(.system(size: 20))
                
                VStack(alignment: .leading) {
                    Text(dspObject.title ?? "Rename this").bold().foregroundColor(Color("FilterText"))
                    Text("\(dspObject.id)").font(.footnote).opacity(0.4)
                }
                
            }.padding(10)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color("FilterBg")))
            .contextMenu {
                Button {

                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Get Info")
                    }
                }
                
                Button {

                } label: {
                    HStack {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        Text("Rename")
                    }
                }
                Divider()
                Button {
                    objectManager.deleteObject(of: dspObject.id)
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }.foregroundColor(.red)
                }
            }
            
        }
        .onReceive(pub) { (output) in
            withAnimation {
                dspObject = objectManager.getObject(id: dspObject.id)!
            }
        }
    }
}
