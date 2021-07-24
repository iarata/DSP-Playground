//
//  SampleConductor.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/23.
//

import Foundation
import SwiftUI
import AVFoundation
import AudioKit

class SamplePlayer: ObservableObject {
    
    let engine = AudioEngine()
    let player = AudioPlayer()
    
    @Published var soundName = ""
    @Published var isPlaying = false
    @Published var isRunning = false
    @AppStorage("selectedAudioPath") var selectedAudioPath: String = ""
    
    func setSoundName(_ s: String){
        soundName = s
    }
    
    func start(){
        if !isPlaying{
            
            let reverb = Reverb(player)
            reverb.dryWetMix = 0.25
            engine.output = reverb
            do {
                if (!isRunning)
                {
                    try engine.start()
                }
                isRunning = true
                player.start()
//                let audioFile = Bundle.main.url(forResource: soundName, withExtension: "mp3")
                let urlFile = URL(fileURLWithPath: selectedAudioPath)
                print(urlFile)
                if urlFile.isFileURL {
                    do {
                        try player.load(url: urlFile)
                    } catch let err {
                        print("#!23 player problem err: \(err.localizedDescription)")
                    }
                    player.volume = 10.0
                    // add some reverb here and balance the volume vs. other apps without clipping noticeably
                    player.play()//not sure if it will loop
                    isPlaying = true
                } else {
                    print("#!18 problem with audioFile")
                }
                
            } catch let err {
                print("#!35 problem with engine err:\(err.localizedDescription)")
            }
        } else {
            print("#41 was already playing")
        }
        
    }
    
    func stop(){
        player.stop()
        isPlaying = false
        //engine.stop()
    }
    
}
