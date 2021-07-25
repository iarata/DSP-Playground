//
//  AudioModel.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/19.
//

import Foundation
import SwiftUI

struct AudioModel: Identifiable, Codable, Hashable {
    var id = UUID()
    var objectID: UUID
    var path: String
    var duration: Double
    
    init(objectID: UUID, path: String, duration: Double) {
        self.objectID = objectID
        self.path = path
        self.duration = duration
    }
}


class AudioModelManager: ObservableObject {
    
    let keyForAudioModels = "Audios"
    
    @Published var audioModels = [AudioModel]()
    @AppStorage("AudioModels") var audioModelsStorage: Data?

    
    // MARK: Add Audio Model
    func add(model: AudioModel) {
        var prevModels = getAll()
        prevModels.append(model)
        let data = prevModels.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: keyForAudioModels)
        self.audioModels = getAll()
        DSPNotification().inspectUpdate(object: self)
    }
    
    // MARK: Get All Audio Models List
    func getAll() -> [AudioModel] {
        guard let encodedData = UserDefaults.standard.array(forKey: keyForAudioModels) as? [Data] else { return [] }
        return encodedData.map { try! JSONDecoder().decode(AudioModel.self, from: $0)}
    }
    
    // MARK: Get an AudioModel
    func get(id: UUID) -> AudioModel {
        let data = getAll()
        var result = AudioModel(objectID: UUID(), path: "", duration: 0.0)
        for model in data {
            if model.id == id {
                result = model
            }
        }
        
        return result
    }
    func get(dspID: UUID) -> AudioModel {
        let data = getAll()
        var result = AudioModel(objectID: UUID(), path: "", duration: 0.0)
        for model in data {
            if model.objectID == dspID {
                result = model
            }
        }
        
        return result
    }
    
    func updateObjectID(newID: UUID, oldID: UUID) {
        
        let prevData = getAll()
        var newData = [AudioModel]()
        for model in prevData {
            if model.objectID == oldID {
                newData.append(AudioModel(objectID: newID, path: model.path, duration: model.duration))
            } else {
                newData.append(model)
            }
        }
        
    }
}
