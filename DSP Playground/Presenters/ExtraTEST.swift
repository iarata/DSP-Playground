//
//  ExtraTEST.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import Foundation
import SwiftUI


func didPressBarItem() -> NSPoint {
    if let event = NSApp.currentEvent, event.isRightClick {
        print("right")
        return NSApp.currentEvent!.locationInWindow
    } else {
        print(NSApp.currentEvent!.locationInWindow)
        return NSApp.currentEvent!.locationInWindow
    }
}

extension NSEvent {
    var isRightClick: Bool {
        let rightClick = (self.type == .rightMouseDown)
        let controlClick = self.modifierFlags.contains(.control)
        return rightClick || controlClick
    }
}


struct RightClickableSwiftUIView: NSViewRepresentable {
    func updateNSView(_ nsView: RightClickableView, context: NSViewRepresentableContext<RightClickableSwiftUIView>) {
        print("Update")
    }
    
    func makeNSView(context: Context) -> RightClickableView {
        RightClickableView()
    }
}

class RightClickableView: NSView {
    override func mouseDown(with theEvent: NSEvent) {
        print("left mouse")
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        print("right mouse")
        print(theEvent.locationInWindow)
    }
}
