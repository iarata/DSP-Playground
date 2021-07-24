//
//  AmplitudeVisualizer.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/20.
//

import SwiftUI
import Shapes

struct AmplitudeVisualizer: View {
    
    var amplitudes: [Double]
    
    var body: some View {
        
        HStack(spacing: 0.0){
            ForEach(0..<self.amplitudes.count, id: \.self) { number in
                VerticalBar(amplitude: self.amplitudes[number])
                
            }
            
            
            
        }.drawingGroup()
        
        //                Chart(data: amplitudes)
        
        
    }
}

