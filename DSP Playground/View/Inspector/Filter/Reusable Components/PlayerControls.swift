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
    @State var sourceName = "Drums"
    @State var isShowingSources = false

    var body: some View {
        HStack(spacing: 10) {

            Button(action: {
                self.isPlaying ? self.conductor.player.stop() : self.conductor.player.play()
                self.isPlaying.toggle()
            }, label: {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
            })
                .padding()
                .background(isPlaying ? Color.red : Color.green)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .cornerRadius(25.0)
                .shadow(color: ColorManager.accentColor.opacity(0.4), radius: 5, x: 0.0, y: 3)
        }

        .padding()
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

