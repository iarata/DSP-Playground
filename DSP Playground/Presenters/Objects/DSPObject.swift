//
//  ObjectModel.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import Foundation

// MARK: An Object Struct
struct DSPObject: Identifiable, Codable {
    var id = UUID()
    var type: ObjectType
    var color: ObjectColor
    var title: String?
    var currentPosition: CGPoint
    
    
    init(type: ObjectType, title: String?, currentPosition: CGPoint) {
        self.type = type
        if let title = title {
            self.title = title
        } else {
            self.title = "\(type)"
        }
        self.currentPosition = currentPosition
        
        switch type {
        case .audioFile:
            self.color = .audioFile
        case .filter:
            self.color = .filter
        case .outputDevice:
            self.color = .outputDevice
        }
    }
    
    init(id: UUID, type: ObjectType, title: String?, currentPosition: CGPoint) {
        self.id = id
        self.type = type
        if let title = title {
            self.title = title
        } else {
            self.title = "\(type)"
        }
        self.currentPosition = currentPosition
        
        switch type {
        case .audioFile:
            self.color = .audioFile
        case .filter:
            self.color = .filter
        case .outputDevice:
            self.color = .outputDevice
        }
    }

}

// MARK: Object Types & Color
enum ObjectType: String, Codable {
    case audioFile = "waveform"
    case outputDevice = "hifispeaker.fill"
    case filter = "slider.vertical.3"
}
enum ObjectColor: String, Codable {
    case audioFile = "AudioFile"
    case outputDevice = "OutputDevice"
    case filter = "Filter"
}

