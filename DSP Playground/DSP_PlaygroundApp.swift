//
//  DSP_PlaygroundApp.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/16.
//

import SwiftUI
//import PythonKit

@main
struct DSP_PlaygroundApp: App {
    
    //    init() {
    //        PythonLibrary.useVersion(3, 9)
    //        PythonConnector().initKit()
    //    }
    var body: some Scene {
        WindowGroup {
            ContentView().frame(width: 1324, height: 700, alignment: .center)
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About DSP Playground") {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                                string: "This is an free app for learning purposes.",
                                attributes: [
                                    NSAttributedString.Key.font: NSFont.boldSystemFont(
                                        ofSize: NSFont.smallSystemFontSize)
                                ]
                            ),
                            NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© \(Calendar.current.component(.year, from: Date())) Hajebrahimi Alireza - UCE.JP"]
                    )
                }
            }
        }
    }
}
