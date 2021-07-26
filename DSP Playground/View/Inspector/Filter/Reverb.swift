//  Created by Alireza Hajebrahimi on 2021/07/18
//

import AudioKit
import AudioKitUI
import AVFoundation
import SwiftUI

struct ReverbData {
    var mix: AUValue = 50
    var volume: AUValue = 0.5
}

class ReverbConductor: ObservableObject, ProcessesPlayerInput {
    let engine = AudioEngine()
    let player = AudioPlayer()
    let buffer: AVAudioPCMBuffer
    let reverb: Reverb
    
    var audioFileURL: String
    
    init(audioFile: String) {
        audioFileURL = audioFile
        buffer = Cookbook().sourceBuffer(url: audioFileURL)
        player.buffer = buffer
        player.isLooping = true
        player.file = try! AVAudioFile(forReading: URL(string: audioFileURL)!)

        reverb = Reverb(player)
        reverb.dryWetMix = 50
        engine.output = reverb
    }
    
    @Published var data = ReverbData() {
        didSet {
            player.volume = data.volume
            reverb.dryWetMix = data.mix
        }
    }
    
    func start() {
        do { try engine.start() } catch let err { Log(err) }
    }

    func stop() {
        engine.stop()
    }
}

struct DSPReverb: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var type: AVAudioUnitReverbPreset
    
    init(title: String, type: AVAudioUnitReverbPreset) {
        self.title = title
        self.type = type
    }
}

struct ReverbView: View {
    @StateObject var conductor: ReverbConductor
    
    @State var selectedReverb: AVAudioUnitReverbPreset = .cathedral
    
    let reverbTypes = [DSPReverb(title: "Cathedral",      type: .cathedral),
                       DSPReverb(title: "Large Hall",     type: .largeHall),
                       DSPReverb(title: "Large Hall 2",   type: .largeHall2),
                       DSPReverb(title: "Large Room",     type: .largeRoom),
                       DSPReverb(title: "Large Room 2",   type: .largeRoom2),
                       DSPReverb(title: "Medium Chamber", type: .mediumChamber),
                       DSPReverb(title: "Medium Hall",    type: .mediumHall),
                       DSPReverb(title: "Medium Hall 2",  type: .mediumHall2),
                       DSPReverb(title: "Medium Hall 3",  type: .mediumHall3),
                       DSPReverb(title: "Meidum Room",    type: .mediumRoom),
                       DSPReverb(title: "Plate",          type: .plate),
                       DSPReverb(title: "Small Room",     type: .smallRoom)]

    var body: some View {
        VStack(spacing: 20) {
            PlayerControls(conductor: conductor)
            VStack(alignment: .leading, spacing: 0) {
                ParameterSlider(text: "Volume", parameter: self.$conductor.data.volume, range: 0...2)
                Text("Values above 1 will have gain applied.").font(.footnote)
            }
            ParameterSlider(text: "Mix", parameter: self.$conductor.data.mix, range: 0...100)
            Cell(leading: "Reverb") {
                Picker("", selection: $selectedReverb) {
                    ForEach(reverbTypes) { rev in
                        Text(rev.title).tag(rev.type)
                    }
                }
            }
            Spacer()
        }
        .onReceive([self.selectedReverb].publisher.first(), perform: { (output) in
            conductor.reverb.loadFactoryPreset(output)
        })
        .padding()
        .onAppear {
            self.conductor.start()
        }
        .onDisappear {
            self.conductor.stop()
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button {
                    DryWetMixView(dry: conductor.player, wet: nil, mix: conductor.reverb).frame(width: 800, height: 400).openInWindow(title: "DryMixer Graph", sender: self)
                } label: {
                    Image(systemName: "waveform.path")
                }
                Menu {
                    Button(action: {
                        FFTView(conductor.player).frame(width: 800, height: 300).openInWindow(title: "Input FFT Bar Graph", sender: self)
                    }) {
                        Text("Input FFT Bar")
                    }
                    
                    Button(action: {
                        FFTView(conductor.reverb).frame(width: 800, height: 300).openInWindow(title: "Reverb FFT BAR Graph", sender: self)
                    }) {
                        Text("Filter FFT Bar")
                    }
                    
                    
                } label: {
                    Image(systemName: "chart.bar.xaxis")
                }
                
                

            }
        }
    }
}
