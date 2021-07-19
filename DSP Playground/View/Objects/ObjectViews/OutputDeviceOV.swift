//
//  OutputDeviceOV.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI

struct OutputDeviceOV: View {
    
    @ObservedObject var objectManager = ObjectManager()
    
    @State var dspObject: DSPObject
    @State var position: CGPoint
    
    @ObservedObject var connectionMG = ConnectionManager()
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: dspObject.type.rawValue).foregroundColor(Color("OutputDeviceText")).font(.system(size: 20))
                VStack(alignment: .leading) {
                    Text(dspObject.title ?? "Rename this").bold().foregroundColor(Color("OutputDeviceText"))
                    Text("\(dspObject.id)").font(.footnote).opacity(0.4)
                }
            }
        }.padding(10)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color("OutputDeviceBg")))

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
}

