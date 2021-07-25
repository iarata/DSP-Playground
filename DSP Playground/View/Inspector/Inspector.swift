//
//  Details.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI

struct Inspector: View {
    
    @StateObject var avmanager = AVManager()
    
    @Binding var objects: [DSPObject]
    @Binding var selected: DSPObject
    @Binding var displayInspect: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Inspector").opacity(0.7)
                Spacer()
                

            }.padding([.horizontal, .top], 7)
            Divider()
            
            if displayInspect {
                if selected.type == .audioFile {
                    AudioInspect(dspObject: $selected, AVMan: avmanager)
                } else if selected.type == .filter && ObjectManager().audioNodeContainsFile() {
                    FilterInspect(dspObject: $selected, AVMan: avmanager)
                }
            }
            
            Spacer()
        }
        .background(VisualEffectView(material: NSVisualEffectView.Material.sidebar, blendingMode: NSVisualEffectView.BlendingMode.withinWindow))

        .frame(maxWidth: 250)
        
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                Spacer()
                
                Button {
                    print("Help")
                } label: {
                    Label("Help", systemImage: "questionmark.circle")
                }
                .help(Text("Help"))
            }
            
        }
    }
    
}
