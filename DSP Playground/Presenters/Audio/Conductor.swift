//
//  Conductor.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/26.
//

import AudioKit
import AudioKitUI
import AudioKitEX
import AVFoundation
import SoundpipeAudioKit
import SwiftUI


struct ConductorData {
    var isPlaying = false
    var isPaused = false
    var volume: AUValue = 1
    var balance: AUValue = 0.5
    var gain: AUValue = 10.0
}

class Conductor: ObservableObject, ProcessesPlayerInput {

    var engine = AudioEngine()
    var player = AudioPlayer()
    var buffer: AVAudioPCMBuffer?
    var filter: Fader?
    var dryWetMixer: DryWetMixer?

    @Published var data = ConductorData() {
        didSet {
            data.isPlaying ? player.play() : player.stop()
            data.isPaused = player.isPaused
            player.volume = data.volume
            filter!.gain = data.gain
            dryWetMixer!.balance = data.balance
        }
    }
    
    var audioFileURL: String?
    
    
    func initFrom(audioFile: String) {
        audioFileURL = audioFile
        buffer = Cookbook().sourceBuffer(url: audioFileURL!)
        player.buffer = buffer
        player.file = try! AVAudioFile(forReading: URL(string: audioFileURL!)!)
        player.isLooping = true
        self.filter = Fader(player)
        self.dryWetMixer = DryWetMixer(player, filter!)
        engine.output = dryWetMixer
    }

    func start() {
        do {
            try engine.start()
        } catch let err {
            Log(err)
        }
    }
    
    func selectFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.title = "Select an audio file"
        panel.allowedFileTypes = ["mp3", "aac", "wav", "flac", "alac", "dsd"]
        if panel.runModal() == .OK {
            self.audioFileURL = panel.url!.absoluteString
        }
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }

    func stop() {
        engine.stop()
    }
}
