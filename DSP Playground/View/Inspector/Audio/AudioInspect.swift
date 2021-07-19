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
    
//    @State var audioFileToProcess =
    
    var body: some View {
        // MARK: - Audio Details
        VStack {
            HStack {
                Text("File Details").bold().font(.footnote).foregroundColor(Color.secondary)
                Spacer()
            }
            Cell(leading: "Title", trailing: dspObject.title ?? "None")
            if selectedAudioPath != "" {
                Cell(leading: "File Type", trailing: URL(string: inspectModel.path)?.pathExtension ?? "Unavailable")
                Cell(leading: "Duration", trailing: timeString(time: TimeInterval(inspectModel.duration)))
                Cell(leading: "Duration", trailing: timeString(time: TimeInterval(inspectModel.duration)))
                Cell(leading: "Path", trailing: inspectModel.path)
            }
            
            HStack {
                Text(dspObject.id.uuidString).font(.footnote)
                Spacer()
            }.padding(.bottom,3)
            
            // MARK: - Audio Progress
            if AVMan.player.isPlaying {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text(timeString(time: TimeInterval(currentTime))).foregroundColor(Color.secondary).padding(.horizontal, 1)
                    }
                    ProgressView(value: (currentTime > AVMan.totalTime) ? AVMan.totalTime : currentTime, total: AVMan.totalTime)
                }
            } 
            
            HStack(spacing: 25) {
                
                // MARK: - Load Button
                Button {
                    withAnimation {
                        selectedAudioPath = AVMan.selectFile()
                        objectMTG.updateName(of: dspObject.id, to: NSURL(string: selectedAudioPath)?.deletingPathExtension?.lastPathComponent ?? "None", position: dspObject.currentPosition)
                        
                        inspectModel = AudioModel(objectID: dspObject.id, path: selectedAudioPath, duration: AVMan.player.duration)
                        audioModelMTG.add(model: inspectModel)
                        DSPNotification().update(object: self)
                    }
                } label: {
                    Image(systemName: "doc.text.fill").font(.system(size: 18))
                }.buttonStyle(PlainButtonStyle())
                .help(Text("Load File"))
                
                // MARK: - Play Button
                Button {
                    withAnimation {
                        if AVMan.player.isPlaying {
                            AVMan.player.stop()
                           
                        } else {
                            AVMan.initAudio(from: selectedAudioPath)
                            AVMan.player.play()
                        }
                    }
                    DispatchQueue.global(qos: .background).async {
                        while AVMan.player.isPlaying {
                            currentTime = AVMan.player.getCurrentTime()
                            
                        }
                        currentTime = 0
                    }
                } label: {
                    Image(systemName: AVMan.player.isPlaying ? "stop.fill" : "play.fill").font(.system(size: 18))
                }.buttonStyle(PlainButtonStyle())
                .help(Text("Play"))
                .disabled(selectedAudioPath == "" ? true : false)
                
                
//                Button("Open Charts") {
//                    TimeDomain().frame(width: 700, height: 300).openInWindow(title: "Graph Freq-Time", sender: self)
//                }
                
                Button("Open Charts") {
                    PythonPlot().openInWindow(title: "PythonKit Test", sender: self)
                }
                
                
            }
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
    }
}
