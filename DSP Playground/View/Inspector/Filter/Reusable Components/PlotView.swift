import AudioKit
import AudioKitUI
import SwiftUI
import AVFoundation

struct DryWetMixView: View {
    var dry: Node
    var wet: Node?
    var mix: Node

    var height: CGFloat = 100

    func plot(_ node: Node, label: String, color: Color) -> some View {
        VStack {
            HStack { Text(label).bold(); Spacer() }.padding([.top, .leading], 6)
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.5, opacity: 0.2))
                    .frame(height: height)
    
                NodeOutputView(node, color: color).frame(height: height).clipped().cornerRadius(12)
            }
        }
    }

    var body: some View {
        VStack(spacing: 30) {
            plot(dry, label: "Input", color: .red).background(Color.white).cornerRadius(12)
            if let wet = self.wet {
                plot(wet, label: "Processed Signal", color: .blue).background(Color.white).cornerRadius(12)
            }
            plot(mix, label: "Mixed Output", color: .purple).background(Color.white).cornerRadius(12)
        }.padding()
    }
}

