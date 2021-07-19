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

class AVManager: ObservableObject {
    
    @AppStorage("selectedAudioPath") var selectedAudioPath: String = ""
    @Published var selectedFile = ""
    @Published var isPlaying = false
    @Published var currentTime = 0.000
    @Published var totalTime = 0.0
    @Published var player =  AudioPlayer()
    @Published var engine = AudioEngine()
    
    func initAudio(from: String) {
        var sourceBuffer: AVAudioPCMBuffer {
            let url = URL(string: from)!
            let file = try! AVAudioFile(forReading: url)
            return try! AVAudioPCMBuffer(file: file)!
        }
        player.isLooping = true
//        player.buffer = sourceBuffer
        player.file = try! AVAudioFile(forReading: URL(string: from)!)
        player.buffer = try! AVAudioPCMBuffer(file: try! AVAudioFile(forReading: URL(string: from)!))!
        engine.output = player
        try! engine.start()
        totalTime = player.duration
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
}

