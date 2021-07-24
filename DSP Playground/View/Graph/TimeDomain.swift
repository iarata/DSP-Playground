//
//  TimeDomain.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI
//import SwiftUICharts
import Combine


struct TimeDomain: View {
    
    @Binding var manager: AVManager
    @State var pub = DSPNotification().publisherPath()
    @State var amps =  [Double]()
    
    
    var body: some View {

        AmplitudeVisualizer(amplitudes: amps)
            .onReceive(pub) { (output) in
                self.amps = manager.amplitudes
            }
            .onAppear {
                self.amps = manager.amplitudes
            }
        
    }
//    var body: some View {
//        HStack(spacing: 0.0){
//            ForEach(0..<self.amplitudes.count, id: \.self) { number in
//                VerticalBar(amplitude: self.$amplitudes[number])
//            }
//            .drawingGroup()
//        }
//        .onReceive(pub) { (output) in
//            self.amps = manager.amplitudes
//        }
//        .onAppear {
//            self.amps = manager.amplitudes
//        }
        
//        MetalView()
//    }
    
        
    
}
