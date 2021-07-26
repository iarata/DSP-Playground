import AudioKit
import AudioKitUI
import AVFoundation
import SoundpipeAudioKit
import SwiftUI

struct HighPassFilterData {
    var cutoffFrequency: AUValue = 1_000
    var resonance: AUValue = 0
    var rampDuration: AUValue = 0.02
    var balance: AUValue = 0.5
    var volume: AUValue = 1
}

class HighPassFilterConductor: ObservableObject, ProcessesPlayerInput {
    let engine = AudioEngine()
    let player = AudioPlayer()
    let filter: HighPassFilter
    let dryWetMixer: DryWetMixer
    let buffer: AVAudioPCMBuffer
    
//    let booster: 
    
    var audioFileURL: String
    
    init(audioFile: String) {
        audioFileURL = audioFile
        buffer = Cookbook().sourceBuffer(url: audioFileURL)
        player.buffer = buffer
        player.file = try! AVAudioFile(forReading: URL(string: audioFileURL)!)
        player.isLooping = true
        
        filter = HighPassFilter(player)
        dryWetMixer = DryWetMixer(player, filter)
        engine.output = dryWetMixer
    }
    
    @Published var data = HighPassFilterData() {
        didSet {
            filter.cutoffFrequency = data.cutoffFrequency
            filter.resonance = data.resonance
            dryWetMixer.balance = data.balance
            player.volume = data.volume
            
        }
    }
    
    func start() {
        do { try engine.start() } catch let err { Log(err) }
    }
    
    func stop() {
        engine.stop()
    }
}

struct HighPassFilterView: View {
    @StateObject var conductor: HighPassFilterConductor
    
    var body: some View {
        ScrollView {
            PlayerControls(conductor: conductor)
            ParameterSlider(text: "Cutoff Frequency",
                            parameter: self.$conductor.data.cutoffFrequency,
                            range: 12.0...3_000.0,
                            units: "Hertz")
            ParameterSlider(text: "Resonance",
                            parameter: self.$conductor.data.resonance,
                            range: -20...40,
                            units: "dB")
            ParameterSlider(text: "Mix",
                            parameter: self.$conductor.data.balance,
                            range: 0...1,
                            units: "%")
            VStack(alignment: .leading, spacing: 0) {
                ParameterSlider(text: "Volume", parameter: self.$conductor.data.volume, range: 0...2)
                Text("Values above 1 will have gain applied.").font(.footnote)
            }
        }
        
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
                    DryWetMixView(dry: conductor.player, wet: conductor.filter, mix: conductor.dryWetMixer).frame(width: 800, height: 500).openInWindow(title: "DryWetMixer Graph", sender: self)
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
                        FFTView(conductor.filter).frame(width: 800, height: 300).openInWindow(title: "Filter FFT BAR Graph", sender: self)
                    }) {
                        Text("Filter FFT Bar")
                    }
                    
                    Button(action: {
                        FFTView(conductor.dryWetMixer).frame(width: 800, height: 300).openInWindow(title: "Mixer FFT Bar Graph", sender: self)
                    }) {
                        Text("Output FFT Bar")
                    }
                } label: {
                    Image(systemName: "chart.bar.xaxis")
                }
                
                

            }
        }
    }
}

