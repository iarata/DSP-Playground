//
//  AudioInspect.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI
import AudioKit
import AudioKitUI
import AVFoundation

struct AudioInspect: View {
    
    @AppStorage("selectedAudioPath") var selectedAudioPath: String = ""
    
    @Binding var dspObject: DSPObject
    
    @State var currentTime = 0.0
    @State var inspectModel = AudioModel(objectID: UUID(), path: "", duration: 0.0)
    
    @State var inspectorUpdates = DSPNotification().inspectPublish()
    @State var dspObjectUpdates = DSPNotification().publisher()
    
    @State var browseButtonHover = false
    
    @StateObject var conductor = Conductor()
    
    var body: some View {
        // MARK: - Audio Details
        VStack {
            HStack {
                Text("File Details").bold().font(.footnote).foregroundColor(Color.secondary)
                Spacer()
            }
            Cell(leading: "Title") { Text(dspObject.title ?? "None").foregroundColor(.secondary) }
            
            if selectedAudioPath != "" {
                Cell(leading: "File Type") { Text(URL(string: inspectModel.path)?.pathExtension ?? "Unavailable").foregroundColor(.secondary) }
                Cell(leading: "Duration") { Text(timeString(time: TimeInterval(inspectModel.duration))).foregroundColor(.secondary) }
                Cell(leading: "Path") { Text(inspectModel.path).foregroundColor(.secondary) }
                
                ParameterSlider(text: "Volume", parameter: self.$conductor.player.volume, range: 0...2)
                Text("Values above 1 will have gain applied.").font(.footnote)
            }
            Cell(leading: "Select File") {
                // MARK: - Load Button
                Button {
                    withAnimation {
                        // open file selecter
                        self.conductor.selectFile()
                        
                        
                        if let audioSet = self.conductor.audioFileURL {
                            selectedAudioPath = audioSet
                            
                            // update object name
                            ObjectManager().updateName(of: dspObject.id, to: NSURL(string: selectedAudioPath)?.deletingPathExtension?.lastPathComponent ?? "None", position: dspObject.currentPosition)
                            
                            ObjectManager().updatePath(of: dspObject.id, to: selectedAudioPath)
                            
                            conductor.initFrom(audioFile: selectedAudioPath)
                            
                            // make audio model
                            inspectModel = AudioModel(objectID: dspObject.id, path: selectedAudioPath, duration: self.conductor.player.duration)
                            
                            // add audio model to model manager
                            AudioModelManager().add(model: inspectModel)
                            
                            
                            
                            // send update notification
                            DSPNotification().update(object: self)
                        }
                        //
                    }
                } label: {
                    Text("Browse").padding(.vertical, 4).padding(.horizontal, 10).overlay(browseButtonHover ? RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color.secondary.opacity(0.1)) : nil)
                }.buttonStyle(PlainButtonStyle())
                .help(Text("Load File"))
                .buttonStyle(PlainButtonStyle())
                .onHover { hover in
                    withAnimation {
                        self.browseButtonHover = hover
                    }
                }
            }
            
            
            
            
            
            HStack(spacing: 25) {
                
                
                
                // MARK: - Play Button
                
                if selectedAudioPath != "" {
                    PlayerControls(conductor: self.conductor)

                }
                
                
                
            }
            Spacer()
            
        }
        .padding(6)
        .onReceive(inspectorUpdates) { (output) in
            inspectModel = AudioModelManager().get(dspID: dspObject.id)
        }
        .onReceive(dspObjectUpdates, perform: { (output) in
            if let newObject = ObjectManager().getObject(id: dspObject.id) {
                self.dspObject = newObject
                self.inspectModel = AudioModelManager().get(dspID: dspObject.id)
                if self.inspectModel.path != "" {
                    self.conductor.initFrom(audioFile: self.inspectModel.path)
                    self.conductor.start()
                }
                
            }
        })
        .onAppear {
            self.inspectModel = AudioModelManager().get(dspID: dspObject.id)
            if self.inspectModel.path != "" {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                    self.currentTime = self.conductor.player.getCurrentTime()
                }
                self.conductor.initFrom(audioFile: self.inspectModel.path)
                self.conductor.start()
            }
        }
        
        .onDisappear {
            Timer().invalidate()
            self.conductor.stop()
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button {
                    FFTView(self.conductor.player).frame(width: 800, height: 300).openInWindow(title: "Graph Freq-Time", sender: self)
                } label: {
                    Label("Bar Chart", systemImage: "chart.bar.xaxis")
                }
            }
        }
    }
}
