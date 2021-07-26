import AudioKit
import AudioKitUI
import AVFoundation
import SwiftUI

protocol ProcessesPlayerInput {
    var player: AudioPlayer { get }
    var engine: AudioEngine { get }
}

struct PlayerControls: View {
    @Environment(\.colorScheme) var colorScheme
    
    var conductor: ProcessesPlayerInput
    
    @State var isPlaying = false
    @State var isPause = false
    
    @State var currentTime: TimeInterval = 0
    
    var body: some View {
        VStack {
            
            // MARK: - Audio Progress
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(timeString(time: TimeInterval(currentTime))).foregroundColor(Color.secondary).padding(.horizontal, 1)
                }
                ProgressView(value: currentTime, total: self.conductor.player.duration)
            }
            HStack(spacing: 10) {
                
                Button(action: {
                    self.conductor.player.play()
                    self.isPlaying = true
                    
                }, label: {
                    Image(systemName: "play.fill").font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(width: 40, height: 40)
                        .imageScale(.medium)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .clipShape(Circle())
                    
                })
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    self.conductor.player.stop()
                    self.isPlaying = false
                                       
                }, label: {
                    Image(systemName: "stop.fill").font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(width: 40, height: 40)
                        .imageScale(.medium)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    
                })
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    self.conductor.player.pause()
                    self.isPlaying = false
                   
                }, label: {
                    Image(systemName: "pause.fill").font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(width: 40, height: 40)
                        .imageScale(.medium)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    
                })
                .buttonStyle(PlainButtonStyle())
                
            }
            
            .padding()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                    if self.isPlaying {
                        self.currentTime = self.conductor.player.getCurrentTime()

                    } else {
                        Timer().invalidate()
                    }
                }
            }
            .onDisappear {
                Timer().invalidate()
            }
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

