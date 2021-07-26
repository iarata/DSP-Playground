import AudioKit
import AudioKitUI
import AVFoundation
import SoundpipeAudioKit
import SwiftUI

//: Band-pass filters allow audio above a specified frequency range and
//: bandwidth to pass through to an output. The center frequency is the starting point
//: from where the frequency limit is set. Adjusting the bandwidth sets how far out
//: above and below the center frequency the frequency band should be.
//: Anything above that band should pass through.
struct BandPassButterworthFilterData {
    var centerFrequency: AUValue = 2_000.0
    var bandwidth: AUValue = 100.0
    var rampDuration: AUValue = 0.02
    var balance: AUValue = 0.5
    var volume: AUValue = 1
}

class BandPassButterworthFilterConductor: ObservableObject, ProcessesPlayerInput {
    let engine = AudioEngine()
    let player = AudioPlayer()
    let filter: BandPassButterworthFilter
    let dryWetMixer: DryWetMixer
    let buffer: AVAudioPCMBuffer

    var audioFileURL: String

    init(audioFile: String) {
        audioFileURL = audioFile
        buffer = Cookbook().sourceBuffer(url: audioFileURL)
        player.buffer = buffer
        player.isLooping = true
        player.file = try! AVAudioFile(forReading: URL(string: audioFileURL)!)

        filter = BandPassButterworthFilter(player)
        dryWetMixer = DryWetMixer(player, filter)
        engine.output = dryWetMixer
    }

    @Published var data = BandPassButterworthFilterData() {
        didSet {
            filter.$centerFrequency.ramp(to: data.centerFrequency, duration: data.rampDuration)
            filter.$bandwidth.ramp(to: data.bandwidth, duration: data.rampDuration)
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

struct BandPassButterworthFilterView: View {
    @StateObject var conductor: BandPassButterworthFilterConductor

    var body: some View {
        ScrollView {
            PlayerControls(conductor: conductor)
            ParameterSlider(text: "Center Frequency",
                            parameter: self.$conductor.data.centerFrequency,
                            range: 12.0...20_000.0,
                            units: "Hertz")
            ParameterSlider(text: "Bandwidth",
                            parameter: self.$conductor.data.bandwidth,
                            range: 0.0...20_000.0,
                            units: "Hertz")
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
