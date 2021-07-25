//
//  FilterModel.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/25.
//

import Foundation
import SwiftUI

struct FilterModel: Identifiable, Codable {
    var id = UUID()
    var boundedTo: UUID
    var path: String
    var type: FilterType
    var audioModelID: UUID
    
    init(boundedTo: UUID, path: String, type: FilterType, audio: UUID) {
        self.boundedTo = boundedTo
        self.path = path
        self.type = type
        self.audioModelID = audio
    }
}

enum FilterType: String, Codable {
    case highPass = "HighPass"
    case lowPass = "LowPass"
    case reverb = "Reverb"
}


class FilterModelManager: ObservableObject {
    
    let keyForFilterModels = "Filters"
    
    @Published var filterModels = [FilterModel]()
    @AppStorage("FilterModels") var filterModelStorage: Data?

    
    // MARK: Add Filter Model
    func add(model: FilterModel) {
        var prevModels = getAll()
        let filtered = prevModels.filter { $0.boundedTo == model.boundedTo }
        if filtered.isEmpty {
            prevModels.append(model)
        }
        let data = prevModels.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: keyForFilterModels)
        self.filterModels = getAll()
        DSPNotification().inspectUpdate(object: self)
    }
    
    // MARK: Add ARRAY of Filter Models
    func add(models: [FilterModel]) {
        let data = models.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: keyForFilterModels)
        self.filterModels = getAll()
        DSPNotification().inspectUpdate(object: self)
    }
    
    // MARK: Get All Filter Models List
    func getAll() -> [FilterModel] {
        guard let encodedData = UserDefaults.standard.array(forKey: keyForFilterModels) as? [Data] else { return [] }
        return encodedData.map { try! JSONDecoder().decode(FilterModel.self, from: $0)}
    }
    
    // MARK: Get an FilterModel
    func get(boundedID: UUID) -> FilterModel {
        let data = getAll()
        var result = FilterModel(boundedTo: UUID(), path: "", type: .highPass, audio: UUID())
        for model in data {
            if model.boundedTo == boundedID {
                result = model
            }
        }
        
        return result
    }
    func get(dspID: UUID) -> FilterModel {
        let data = getAll()
        var result = FilterModel(boundedTo: UUID(), path: "", type: .highPass, audio: UUID())
        for model in data {
            if model.boundedTo == dspID {
                result = model
            }
        }
        
        return result
    }
    
    // MARK: Update Associated AudioModel
    func updateFilterAudioModel(of: UUID, to: UUID) {
        let prevData = getAll()
        var newData = [FilterModel]()
        for model in prevData {
            if model.boundedTo == of {
                newData.append(FilterModel(boundedTo: model.boundedTo, path: model.path, type: model.type, audio: to))
            } else {
                newData.append(model)
            }
        }
        self.add(models: newData)
    }
    
    // MARK: Update Associated Filter ID
    func updateFilterID(newID: UUID, oldID: UUID) {
        let prevData = getAll()
        var newData = [FilterModel]()
        for model in prevData {
            if model.boundedTo == oldID {
                newData.append(FilterModel(boundedTo: newID, path: model.path, type: model.type, audio: model.audioModelID))
            } else {
                newData.append(model)
            }
        }
        
    }
}
