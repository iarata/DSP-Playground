//
//  Details.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI

struct Inspector: View {
    
    @ObservedObject var avmanager = AVManager()
    
    @Binding var objects: [DSPObject]
    @Binding var selected: DSPObject
    @Binding var displayInspect: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Inspector").opacity(0.7)
                Spacer()
                Button {
                    withAnimation {
                        self.displayInspect.toggle()
                    }
                } label: {
                    Image(systemName: "sidebar.trailing")
                }.buttonStyle(PlainButtonStyle())

            }.padding([.horizontal, .top], 7)
            Divider()
            
            if selected.type == .audioFile {
                AudioInspect(dspObject: $selected, AVMan: avmanager)
            }
            
            Spacer()
        }

        .frame(width: 250)
        
        
    }
    
}
extension View {
    
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let win = NSWindow(contentViewController: controller)
        win.contentViewController = controller
        win.title = title
        win.makeKeyAndOrderFront(sender)
        return win
    }
}


struct Cell: View {
    var leading: String
    var trailing: String
    
    var body: some View {
        HStack {
            Text(leading)
            Spacer()
            Text(trailing).foregroundColor(.secondary)
        }.padding(7).background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color.white))
    }
}
