//
//  AudioManager.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import Foundation
import AVFoundation
import SwiftUI
import AudioKit
import Accelerate

class AVManager: ObservableObject {
    
    @Published var amplitudes: [Double] = Array(repeating: 0.5, count: 50)
    
    @AppStorage("selectedAudioPath") var selectedAudioPath: String = ""
    @Published var selectedFile = ""
    @Published var isPlaying = false
    @Published var currentTime = 0.000
    @Published var totalTime = 0.0
    @Published var player =  AudioPlayer()
    @Published var engine = AudioEngine()
    
    @Published var mixer = Mixer()
    @Published var sMixer = Mixer()
    
    /// FFT Tap
    var fft: FFTTap!
    
    /// size of fft
    let FFT_SIZE = 1024
    
    /// audio sample rate
    let sampleRate : double_t = 44100
        
    func initAudio(from: String) {
        player.isLooping = false
        player.file = try! AVAudioFile(forReading: URL(string: from)!)
        player.buffer = try! AVAudioPCMBuffer(file: try! AVAudioFile(forReading: URL(string: from)!))!
        
        mixer = Mixer(player)
        
        
        engine.output = mixer
        
//        ifft.windowType = .hanning
        
        totalTime = player.duration
    }
    
    // Start playing
    func start() {
        fft = FFTTap(mixer) { fftData in
            DispatchQueue.main.async {
                self.updateAmplitudes(fftData)
                
                DSPNotification().updatePath(object: self)
            }
        }
        
        do {
            try engine.start()
            fft.start()
        } catch {
            assert(false, error.localizedDescription)
        }

        player.start()
        isPlaying = true
    }
    
    func stop() {
        fft.stop()
        player.stop()
        isPlaying = false
    }
    
    func selectFile() -> String {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.title = "Select an audio file"
        panel.allowedFileTypes = ["mp3", "aac", "wav", "flac", "alac", "dsd"]
        if panel.runModal() == .OK {
            self.selectedFile = panel.url!.absoluteString
            self.selectedAudioPath = panel.url!.absoluteString
        }
        initAudio(from: selectedAudioPath)
        return panel.url?.absoluteString ?? ""
    }
    
    
    func updateAmplitudes(_ fftData: [Float]) {
        
        
        
        //        ifft.fftForward(fftData)
        //        ifft.calculateLogarithmicBands(minFrequency: 100, maxFrequency: 11025, bandsPerOctave: 8)
        //        for i in 0..<ifft.numberOfBands {
        //            let f = ifft.frequencyAtBand(i)
        //            let m = ifft.magnitudeAtBand(i)
        //            let sas = ifft.bandFrequencies
        //
        //            DispatchQueue.main.async {
        ////                print(sas)
        ////                print(f)
        //                print(m)
        //            }
        //        }
        // loop by two through all the fft data
        for i in stride(from: 0, to: self.FFT_SIZE - 1, by: 2) {
            
            // get the real and imaginary parts of the complex number
            let real: Float = fftData[i]
            let imaginary = fftData[i + 1]
            let normalizedBinMagnitude = 2.0 * sqrt(real * real + imaginary * imaginary) / Float(self.FFT_SIZE)
            let amplitude = Double(20.0 * log10(normalizedBinMagnitude))
            
            // scale the resulting data
            let scaledAmplitude = (amplitude + 250) / 229.80
            
            // add the amplitude to our array (further scaling array to look good in visualizer)
            DispatchQueue.main.async {
                if(i/2 < self.amplitudes.count){
                    var mappedAmplitude = self.map(n: scaledAmplitude, start1: 0.3, stop1: 0.9, start2: 0.0, stop2: 1.0)
                    
                    // restrict the range to 0.0 - 1.0
                    if (mappedAmplitude < 0) {
                        mappedAmplitude = 0
                    }
                    if (mappedAmplitude > 1.0) {
                        mappedAmplitude = 1.0
                    }
                    
                    self.amplitudes[i/2] = mappedAmplitude
                }
            }
        }
    }
    
    // simple mapping function to scale a value to a different range
    func map(n:Double, start1:Double, stop1:Double, start2:Double, stop2:Double) -> Double {
        return ((n-start1)/(stop1-start1))*(stop2-start2)+start2;
    };
    
    
    
}

