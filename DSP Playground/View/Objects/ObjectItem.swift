//
//  ObjectItem.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import SwiftUI

struct ObjectItem: View {
    
    @State var typeOfItem: ObjectType
    
    var body: some View {
        switch typeOfItem {
        case .audioFile:
            return HStack {
                Image(systemName: "waveform").font(.system(size: 18))
                VStack(alignment:.leading) {
                    Text("Audio File").font(.system(size: 14)).bold()
                    Text("Select an audio file to modify.").font(.footnote)
                }
                Spacer()
            }.padding(.leading, 2).padding(5)
        case .filter:
            return HStack {
                Image(systemName: "slider.vertical.3").font(.system(size: 18))
                VStack(alignment:.leading) {
                    Text("Filter").font(.system(size: 14)).bold()
                    Text("Modify audio signals.").font(.footnote)
                }
                Spacer()
            }.padding(.leading, 2).padding(5)
        case .outputDevice:
            return HStack {
                Image(systemName: "hifispeaker.fill").font(.system(size: 18))
                VStack(alignment:.leading) {
                    Text("Output Device").font(.system(size: 14)).bold()
                    Text("An output device for play the audio.").font(.footnote)
                }
                Spacer()
            }.padding(.leading, 2).padding(5)
        }
    }
}
