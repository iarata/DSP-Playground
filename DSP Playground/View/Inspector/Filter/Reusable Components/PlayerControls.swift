import AudioKit
import AudioKitUI
import AVFoundation
import SwiftUI

protocol ProcessesPlayerInput {
    var player: AudioPlayer { get }
}

struct PlayerControls: View {
    @Environment(\.colorScheme) var colorScheme
    
    var conductor: ProcessesPlayerInput
    
    @State var isPlaying = false
    @State var isPause = false
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                
                Button(action: {
                    self.isPlaying ? self.conductor.player.stop() : self.conductor.player.play()
                    self.isPlaying.toggle()
                    
                }, label: {
                    Image(systemName: isPlaying ? "stop.fill" : "play.fill").font(.system(size: 18, weight: .semibold, design: .rounded))
                        //                        .padding(5)
                        .frame(width: 40, height: 40)
                        .imageScale(.medium)
                        .foregroundColor(.white)
                        .background(isPlaying ? Color.red : Color.green)
                        .clipShape(Circle())
                    
                })
                .buttonStyle(PlainButtonStyle())
                
                
                Button(action: {
                    self.isPause ? self.conductor.player.play() : self.conductor.player.pause()
                    self.isPause.toggle()
                    
                }, label: {
                    Image(systemName: isPause ? "playpause.fill" : "pause.fill").font(.system(size: 18, weight: .semibold, design: .rounded))
                        //                        .padding(5)
                        
                        .frame(width: 40, height: 40)
                        .imageScale(.medium)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    
                })
                .buttonStyle(PlainButtonStyle())
                
            }
            
            .padding()
        }
    }
    
    func load(filename: String) {
        conductor.player.stop()
        
        Log(filename)
        
        guard let url = Bundle.main.resourceURL?.appendingPathComponent("Samples/\(filename)"),
              let buffer = try? AVAudioPCMBuffer(url: url) else {
            Log("failed to load sample", filename)
            return
        }
        conductor.player.isLooping = false
        conductor.player.buffer = buffer
        
        if isPlaying {
            conductor.player.play()
        }
    }
}

