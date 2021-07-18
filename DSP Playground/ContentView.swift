//
//  ContentView.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/16.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            Sidebar()
            Home()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
