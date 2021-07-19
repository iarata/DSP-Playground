//
//  AudioInspectPlayer.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/19.
//

import SwiftUI

struct AudioInspectPlayer: View {
    var body: some View {
        GeometryReader { geomatry in
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray).frame(height: 4)
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color("PlayerPassed")).frame(height: 4)
            }
        }
    }
}
