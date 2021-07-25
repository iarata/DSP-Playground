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
    
    @Binding var dspObject: DSPObject
    
    @State var AVMan: AVManager

    @State var inspectorUpdates = DSPNotification().inspectPublish()
    @State var dspObjectUpdates = DSPNotification().publisher()
    
    @State var filterModelName = ""
    
    @State var audioModels = [AudioModel]()
    @State var selectedAudioModel = AudioModel(objectID: UUID(), path: "", duration: 0.0)

    @State var selectedFilterType:FilterType = .highPass
    
    @State var showFilter = false
        
    var body: some View {
        // MARK: - Filter Details
        VStack {
            Cell(leading: "Title") {
                TextField("", text: $filterModelName)
                    .foregroundColor(.secondary)
                    .textFieldStyle(PlainTextFieldStyle())

            }
            
            Cell(leading: "Audio") {
                Picker("", selection: $selectedAudioModel) {
                    ForEach(audioModels) { model in
                        Text(objectMTG.getObject(id: model.objectID)?.title ?? "Audio File").tag(model)
                    }
                }

            }
            
            Cell(leading: "Filter") {
                Picker("", selection: $selectedFilterType) {
                    Text("High Pass").tag(FilterType.highPass)
                    Text("Low Pass").tag(FilterType.lowPass)
                    Text("Reverb").tag(FilterType.reverb)
                }
            }
            
            Button("Generate Filter") {
                withAnimation {
                    objectMTG.updateName(of: dspObject.id, to: filterModelName, position: dspObject.currentPosition)
                    
                    if self.selectedAudioModel.path != "" {
                        self.showFilter = true
                    }
                    
                    DSPNotification().update(object: self)
                }
            }
            
            if self.showFilter {
                switch selectedFilterType {
                case .highPass:
                    HighPassFilterView(conductor: HighPassFilterConductor(audioFile: AVMan.selectedAudioPath))
                case .lowPass:
                    Text("asc")
                case .reverb:
                    Text("as")
                }
            }
            Spacer()
            
        }
        .onTapGesture {
            
        }
        .padding(6)
        .onAppear {
            self.filterModelName = dspObject.title ?? ""
            self.audioModels = AudioModelManager().getAll()
            
            
            
        }
//        .onReceive([self.selectedAudioModel].publisher) { (output) in
//            print(selectedAudioModel.path)
//        }
    }
}
