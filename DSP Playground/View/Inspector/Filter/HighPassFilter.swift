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
    var volume: AUValue = 0.5
}

class HighPassFilterConductor: ObservableObject, ProcessesPlayerInput {
    let engine = AudioEngine()
    let player = AudioPlayer()
    let filter: HighPassFilter
    let dryWetMixer: DryWetMixer
    let buffer: AVAudioPCMBuffer
    
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
            Button("Specturm") {
                DryWetMixView(dry: conductor.player, wet: conductor.filter, mix: conductor.dryWetMixer).frame(width: 700, height: 400).openInWindow(title: "Specturm", sender: self)
            }
        }
        
        .padding()
        .onAppear {
            self.conductor.start()
            print(conductor.audioFileURL)
        }
        .onDisappear {
            self.conductor.stop()
        }
    }
}
