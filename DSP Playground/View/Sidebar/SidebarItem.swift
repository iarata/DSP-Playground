//
//  SidebarItem.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import SwiftUI

struct SidebarItem: View {
    
    @State var item: DSPObject
    @State var pub = DSPNotification().publisher()
    
    var body: some View {
        HStack {
            Image(systemName: item.type.rawValue)
            Text(item.title ?? item.color.rawValue)
        }
        
        .onReceive(pub) { (output) in
            if let updateDSP = ObjectManager().getObject(id: item.id) {
                withAnimation {
                    self.item = updateDSP
                }
            }
            
        }
        
    }
    
    
}
