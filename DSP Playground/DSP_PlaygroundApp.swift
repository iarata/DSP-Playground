//
//  DSP_PlaygroundApp.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/16.
//

import SwiftUI
import PythonKit

@main
struct DSP_PlaygroundApp: App {
    
    init() {
        PythonLibrary.useVersion(3, 9)
    }
    var body: some Scene {
        WindowGroup {
            ContentView().frame(width: 1324, height: 700, alignment: .center)
        }
    }
}
