import AudioKit
import AudioKitUI
import AVFoundation
import SoundpipeAudioKit
import SwiftUI

struct TanhDistortionData {
    var pregain: AUValue = 2.0
    var postgain: AUValue = 0.5
    var positiveShapeParameter: AUValue = 0.0
    var negativeShapeParameter: AUValue = 0.0
    var rampDuration: AUValue = 0.02
    var balance: AUValue = 0.5
    var volume: AUValue = 1
}

class TanhDistortionConductor: ObservableObject, ProcessesPlayerInput {
    let engine = AudioEngine()
    let player = AudioPlayer()
    let distortion: TanhDistortion
    let dryWetMixer: DryWetMixer
    let buffer: AVAudioPCMBuffer

    var audioFileURL: String

    init(audioFile: String) {
        audioFileURL = audioFile
        buffer = Cookbook().sourceBuffer(url: audioFileURL)
        player.buffer = buffer
        player.isLooping = true
        player.file = try! AVAudioFile(forReading: URL(string: audioFileURL)!)
        
        distortion = TanhDistortion(player)
        dryWetMixer = DryWetMixer(player, distortion)
        engine.output = dryWetMixer
    }

    @Published var data = TanhDistortionData() {
        didSet {
            distortion.$pregain.ramp(to: data.pregain, duration: data.rampDuration)
            distortion.$postgain.ramp(to: data.postgain, duration: data.rampDuration)
            distortion.$positiveShapeParameter.ramp(to: data.positiveShapeParameter, duration: data.rampDuration)
            distortion.$negativeShapeParameter.ramp(to: data.negativeShapeParameter, duration: data.rampDuration)
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

struct TanhDistortionView: View {
    @StateObject var conductor: TanhDistortionConductor

    var body: some View {
        ScrollView {
            PlayerControls(conductor: conductor)
            ParameterSlider(text: "Pregain",
                            parameter: self.$conductor.data.pregain,
                            range: 0.0...10.0,
                            units: "Generic")
            ParameterSlider(text: "Postgain",
                            parameter: self.$conductor.data.postgain,
                            range: 0.0...10.0,
                            units: "Generic")
            ParameterSlider(text: "Positive Shape Parameter",
                            parameter: self.$conductor.data.positiveShapeParameter,
                            range: -10.0...10.0,
                            units: "Generic")
            ParameterSlider(text: "Negative Shape Parameter",
                            parameter: self.$conductor.data.negativeShapeParameter,
                            range: -10.0...10.0,
                            units: "Generic")
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
                    DryWetMixView(dry: conductor.player, wet: conductor.distortion, mix: conductor.dryWetMixer).frame(width: 800, height: 500).openInWindow(title: "DryWetMixer Graph", sender: self)
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
                        FFTView(conductor.distortion).frame(width: 800, height: 300).openInWindow(title: "Distortion FFT BAR Graph", sender: self)
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

