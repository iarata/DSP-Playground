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
                Cell(leading: "Path", trailing: inspectModel.path)
            }
            
            HStack {
                Text(dspObject.id.uuidString).font(.footnote)
                Spacer()
            }.padding(.bottom,3)
            
            if AVMan.player.isPlaying {
                ProgressView(value: currentTime, total: AVMan.totalTime)
            } 
            
            HStack(spacing: 25) {
                
                // MARK: - Load Button
                Button {
                    
                    selectedAudioPath = AVMan.selectFile()
                    objectMTG.updateName(of: dspObject.id, to: NSURL(string: selectedAudioPath)?.deletingPathExtension?.lastPathComponent ?? "None", position: dspObject.currentPosition)
                    
                    inspectModel = AudioModel(objectID: dspObject.id, path: selectedAudioPath, duration: AVMan.player.duration)
                    audioModelMTG.add(model: inspectModel)
                    DSPNotification().update(object: self)
                } label: {
                    Image(systemName: "doc.text.fill").font(.system(size: 18))
                }.buttonStyle(PlainButtonStyle())
                .help(Text("Load File"))
                
                // MARK: - Play Button
                Button {
                    if AVMan.player.isPlaying {
                        AVMan.player.stop()
                    } else {
                        AVMan.initAudio(from: selectedAudioPath)
                        AVMan.player.play()
                    }
                    DispatchQueue.global(qos: .background).async {
                        while AVMan.player.isPlaying {
                            currentTime = AVMan.player.getCurrentTime()
                        }
                    }
                } label: {
                    Image(systemName: "play.fill").font(.system(size: 18))
                }.buttonStyle(PlainButtonStyle())
                .help(Text("Play"))
                .disabled(selectedAudioPath == "" ? true : false)
                
                
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
