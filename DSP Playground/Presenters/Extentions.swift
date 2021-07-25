//
//  Extentions.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import Foundation
import SwiftUI

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension View {
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
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

struct Cell<Content: View>: View {
    let leading: String
    let content: Content
    
    init(leading: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.leading = leading
    }
    
    var body: some View {
        HStack {
            Text(leading)
            Spacer()
            content
        }.padding(7).background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color.white))
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
