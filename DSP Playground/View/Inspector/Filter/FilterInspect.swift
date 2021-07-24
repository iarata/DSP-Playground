//
//  FilterInspect.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/25.
//

import SwiftUI

struct FilterInspect: View {
    
    @AppStorage("selectedAudioPath") var selectedAudioPath: String = ""
    @ObservedObject var audioModelMTG = AudioModelManager()
    @ObservedObject var objectMTG = ObjectManager()
    
    @Binding var dspObject: DSPObject {
        didSet {
            inspectModel = audioModelMTG.get(dspID: dspObject.id)
        }
    }
    
    @State var AVMan: AVManager
    @State var currentTime = 0.0
    @State var inspectModel = AudioModel(objectID: UUID(), path: "", duration: 0.0)
    
    @State var inspectorUpdates = DSPNotification().inspectPublish()
    @State var dspObjectUpdates = DSPNotification().publisher()
        
    var body: some View {
        // MARK: - Filter Details
        VStack {
            HighPassFilterView(conductor: HighPassFilterConductor(audioFile: AVMan.selectedAudioPath))
            Spacer()
            
            // Object UUID
            HStack {
                Text(dspObject.id.uuidString).font(.footnote)
                Spacer()
            }.padding(.bottom,3)
        }
    }
}
