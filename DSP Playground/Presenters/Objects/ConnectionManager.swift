//
//  ConnectionManager.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import Foundation

struct ConnectionModel: Identifiable, Codable {
    var id = UUID()
    var objectID: UUID
    var linePoints: [SubConnection]
}

struct SubConnection: Codable {
    var name: String
    var from: CGPoint
    var to: CGPoint
}

// MARK: Connection Manager
class ConnectionManager: ObservableObject {
    
    let keyForConnectionStorage = "ConnectionStorage"
    
    @Published var connections = [ConnectionModel]()
    
    @Published var connecting = false
    
    func initConnection(start: CGPoint)
    {
        
    }
    
    // MARK: - Add a Path
    func addPath(id: UUID, subs: [SubConnection]) {
        var prevData = getPaths()
        prevData.append(ConnectionModel(objectID: id, linePoints: subs))
        let data = prevData.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: keyForConnectionStorage)
        self.connections = getPaths()
        print(subs)
        DSPNotification().updatePath(object: self)
    }
    
    // MARK: - Get Paths
    func getPaths() -> [ConnectionModel] {
        guard let encodedData = UserDefaults.standard.array(forKey: keyForConnectionStorage) as? [Data] else { return [] }
        return encodedData.map { try! JSONDecoder().decode(ConnectionModel.self, from: $0) }
    }
    
    func getPath(id: UUID) -> ConnectionModel {
        var result = ConnectionModel(objectID: id, linePoints: [SubConnection(name: "", from: CGPoint(x: 0,y: 0), to: CGPoint(x: 0,y: 0))])
        for item in getPaths() {
            if item.objectID == id {
                result = item
            }
        }
        
        return result
    }
}
