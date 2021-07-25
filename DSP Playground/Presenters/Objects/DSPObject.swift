//
//  ObjectModel.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import Foundation

// MARK: An Object Struct
struct DSPObject: Identifiable, Codable, Equatable {
    var id = UUID()
    var type: ObjectType
    var color: ObjectColor
    var title: String?
    var currentPosition: CGPoint
    var filePath: String?
    
    
    init(type: ObjectType, title: String?, currentPosition: CGPoint, path: String?) {
        self.type = type
        if let title = title {
            self.title = title
        } else {
            switch type {
            case .audioFile:
                self.title = "Audio File Node"
            case .filter:
                self.title = "Filter Node"
            case .outputDevice:
                self.title = "Output Node"
            }
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
        if let path = path {
            self.filePath = path
        }
    }
    
    init(id: UUID, type: ObjectType, title: String?, currentPosition: CGPoint, path: String?) {
        self.id = id
        self.type = type

        if let title = title {
            self.title = title
        } else {
            switch type {
            case .audioFile:
                self.title = "Audio File Node"
            case .filter:
                self.title = "Filter Node"
            case .outputDevice:
                self.title = "Output Node"
            }
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
        
        if let path = path {
            self.filePath = path
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

