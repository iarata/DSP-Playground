//
//  Sidebar.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import SwiftUI

struct Sidebar: View {
    
    @State var objects = [DSPObject]()
    @State var pub = DSPNotification().publisher()
    @State var selected: UUID?
    
    var body: some View {
        List(selection: $selected) {
            Section(header: Text("Workspace")) {
                ForEach(objects) { obj in
                    SidebarItem(item: obj).tag(obj.id)
                }
            }
        }
        
        .listStyle(SidebarListStyle())
        .frame(minWidth: 220)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
                .help(Text("Toggle Sidebar"))
            }
        }
        .onAppear {
            objects = ObjectManager().getObjects()
        }
        .onReceive(pub) { (output) in
            withAnimation {
                objects = ObjectManager().getObjects()
            }
        }
        
        
    }
    
}

func toggleSidebar() {
    #if os(macOS)
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    #endif
}
