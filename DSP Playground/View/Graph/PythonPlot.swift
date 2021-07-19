//
//  PythonPlot.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/19.
//

import SwiftUI
import PythonKit

struct PythonPlot: View {
    
    @State var myConnector = PythonConnecting()
    @ObservedObject var objectMTG = ObjectManager()
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button("Test") {
                myConnector.pythonHello()
            }
        }.frame(width: 200, height: 300)
    }
    
    
}

class PythonConnecting {
    
    var error: String?
    
//    init() {
//        PythonLibrary.useVersion(3, 9)
//    }
    
    func run() {
        
        let sys = Python.import("sys")
        let os = Python.import("os")
        
        print("Python \(sys.version_info.major).\(sys.version_info.major)")
        print("Python Version: \(sys.version)")
        print("Python Encoding: \(sys.getdefaultencoding().upper())")
        print("Working Directory: \(os.getcwd())")
        let myPath = "/Users/alireza/Desktop/iOS/DSP Playground/DSP Playground/Python/"
        sys.path.append(myPath)
        let dte = sys.path
        print(dte)
        
        error = String(sys.version)
        
    }
    
    func pythonHello() {
        let sys = Python.import("sys")
        let os = Python.import("os")
        
        print("Python \(sys.version_info.major).\(sys.version_info.major)")
        print("Python Version: \(sys.version)")
        print("Python Encoding: \(sys.getdefaultencoding().upper())")
        print("Working Directory: \(os.getcwd())")
        let myPath = "/Users/alireza/Desktop/iOS/DSP Playground/DSP Playground/Python/"
        let path = String(Bundle.main.resourcePath!)
        sys.path.append(path)
        print(Bundle.main.resourcePath!)
        sys.path.append(myPath)
        
        do {
            let ronn = try Python.attemptImport("PythonKitTest")
            var breakLoo = ronn.breakLOOP
            print(breakLoo)
            breakLoo = true
            print(breakLoo)
        } catch {
            print(error)
        }
        
//        error = String(sys.version)
//        let helloTest = Python.import("PythonKitTest")
        
    }
    
}
