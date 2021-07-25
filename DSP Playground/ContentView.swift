//
//  ContentView.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/16.
//

import SwiftUI

struct ContentView: View {
    
    @State var objects = [DSPObject]()
    @State var selectedElement = DSPObject(id: UUID(), type: .audioFile, title: "", currentPosition: CGPoint(x:0, y:0), path: "")
    @State var showInspector = false
    
    var body: some View {
        NavigationView {
            Sidebar()
            Home(objects: $objects, showInspector: $showInspector, selectedElement: $selectedElement)
            Inspector(objects: $objects, selected: $selectedElement, displayInspect: $showInspector)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
