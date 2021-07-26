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
    @ObservedObject var filterMTG = FilterModelManager()
    @ObservedObject var objectMTG = ObjectManager()
    
    @Binding var dspObject: DSPObject
    @State var filterObject = FilterModel(boundedTo: UUID(), path: "", type: .highPass, audio: UUID())
        
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
                HStack {
                    Spacer()
                    TextField("", text: $filterModelName)
                        .foregroundColor(.secondary)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                
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
                    Text("Band Pass").tag(FilterType.BandPass)
                    Text("Tanh Distortion").tag(FilterType.TanhDistortion)
                    Text("Reverb").tag(FilterType.reverb)
                }
            }
            
            Button("Generate Filter") {
                withAnimation {
                    objectMTG.updateName(of: dspObject.id, to: filterModelName, position: dspObject.currentPosition)
                    print(selectedAudioModel)
                    if self.selectedAudioModel.path != "" {
                        self.showFilter = true
                        self.filterObject = FilterModel(boundedTo: dspObject.id, path: selectedAudioModel.path, type: selectedFilterType, audio: selectedAudioModel.id)
                        filterMTG.add(model: self.filterObject)
                    }
                    
                    DSPNotification().update(object: self)
                }
            }
            
            if self.showFilter && (selectedAudioModel.path != "") {
                switch selectedFilterType {
                case .highPass:
                    HighPassFilterView(conductor: HighPassFilterConductor(audioFile: selectedAudioModel.path))
                case .lowPass:
                    LowPassFilterView(conductor: LowPassFilterConductor(audioFile: selectedAudioModel.path))
                case .reverb:
                    ReverbView(conductor: ReverbConductor(audioFile: selectedAudioModel.path))
                case .BandPass:
                    BandPassButterworthFilterView(conductor: BandPassButterworthFilterConductor(audioFile: selectedAudioModel.path))
                case .TanhDistortion:
                    TanhDistortionView(conductor: TanhDistortionConductor(audioFile: selectedAudioModel.path))
                }
            }
            Spacer()
            
        }
        .onTapGesture {
            
        }
        .padding(6)
        .onAppear {
            print("scs")
            self.filterModelName = dspObject.title ?? ""
            self.audioModels = AudioModelManager().getAll()
            
            if filterMTG.getAll().isNotEmpty {
                self.filterObject = filterMTG.get(boundedID: dspObject.id)

                if let modelExists = audioModelMTG.get(id: filterObject.audioModelID) {
                    self.selectedAudioModel = modelExists
                }
                self.selectedFilterType = filterObject.type
                self.showFilter = true
            }
            
            
        }
        .onReceive([self.selectedAudioModel].publisher.first()) { (output) in
            if self.filterObject.audioModelID != selectedAudioModel.id {
                self.showFilter = false
                self.filterMTG.remove(id: self.filterObject.id)
            }
        }
        .onReceive([self.selectedFilterType].publisher.first()) { (output) in
            if self.filterObject.type != selectedFilterType {
                self.showFilter = false
                self.filterMTG.remove(id: self.filterObject.id)
            }
        }
        
        
        
    }
}
