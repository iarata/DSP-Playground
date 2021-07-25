//
//  AudioInspect.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import SwiftUI

struct AudioInspect: View {
    
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
    @State var amsc = [0.0, 0.0, 0.0]
    
    @State var browseButtonHover = false
        
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
            }
            Cell(leading: "Select File") {
                // MARK: - Load Button
                Button {
                    withAnimation {
                        // open file selecter
                        selectedAudioPath = AVMan.selectFile()
                        
                        // update object name
                        objectMTG.updateName(of: dspObject.id, to: NSURL(string: selectedAudioPath)?.deletingPathExtension?.lastPathComponent ?? "None", position: dspObject.currentPosition)
                        
                        objectMTG.updatePath(of: dspObject.id, to: selectedAudioPath)
                        
                        // make audio model
                        inspectModel = AudioModel(objectID: dspObject.id, path: selectedAudioPath, duration: AVMan.player.duration)
                        
                        // add audio model to model manager
                        audioModelMTG.add(model: inspectModel)
                        
                        
                        // send update notification
                        DSPNotification().update(object: self)
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
            
            
            
            // MARK: - Audio Progress
            if AVMan.isPlaying {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text(timeString(time: TimeInterval(currentTime))).foregroundColor(Color.secondary).padding(.horizontal, 1)
                    }
                    ProgressView(value: (currentTime > AVMan.totalTime) ? AVMan.totalTime : currentTime, total: AVMan.totalTime)
                }
            } 
            
            HStack(spacing: 25) {
                
                
                
                // MARK: - Play Button
                Button {
                    withAnimation {
                        if AVMan.isPlaying {
                            AVMan.stop()
                        } else {
                            AVMan.initAudio(from: selectedAudioPath)
                            AVMan.start()
                        }
                        
                    }
                    DispatchQueue.global(qos: .background).async {
                        currentTime = 0
                        while AVMan.isPlaying && AVMan.player.getCurrentTime() != inspectModel.duration {
                            amsc = AVMan.amplitudes
                            currentTime = AVMan.player.getCurrentTime()
                        }
                        AVMan.stop()

                    }
                } label: {
                    Image(systemName: AVMan.player.isPlaying ? "stop.fill" : "play.fill").font(.system(size: 18))
                }.buttonStyle(PlainButtonStyle())
                .help(Text("Play"))
                .disabled(selectedAudioPath == "" ? true : false)
                
                
                Button("Open Charts") {
                    TimeDomain(manager: $AVMan).frame(width: 800, height: 300).drawingGroup().openInWindow(title: "Graph Freq-Time", sender: self)
                }
                
//                Button("Open Charts") {
//                    PythonPlot().openInWindow(title: "PythonKit Test", sender: self)
//                }
                
                
            }
            Spacer()
            
        }
        .padding(6)
        .onReceive(inspectorUpdates) { (output) in
            inspectModel = audioModelMTG.get(dspID: dspObject.id)
        }
        .onReceive(dspObjectUpdates, perform: { (output) in
            if let newObject = objectMTG.getObject(id: dspObject.id) {
                self.dspObject = newObject
            }
        })
        .onAppear {
            inspectModel = audioModelMTG.get(dspID: dspObject.id)
        }
        
        .onDisappear {
            AVMan.player.stop()
        }
    }
}
