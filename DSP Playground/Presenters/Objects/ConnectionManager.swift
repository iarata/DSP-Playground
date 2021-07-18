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

struct InitialConnection: Identifiable, Codable {
    var id = UUID()
    var start: UUID
    var end: UUID?
}

// MARK: Connection Manager
class ConnectionManager: ObservableObject {
    
    let keyForConnectionStorage = "ConnectionStorage"
    
    @Published var connections = [InitialConnection]()
    @Published var connecting = false
    @Published var publicConnection = InitialConnection(start: UUID(), end: nil)
    
    func initStart(start: UUID) {
        connecting = true
        publicConnection.start = start
    }
    func initStop(stop: UUID) {
        publicConnection.end = stop
        connecting = false
        addConnection(connection: publicConnection)
    }
    
    // MARK: Add Connection
    func addConnection(connection: InitialConnection) {
        var prevConnections = getConnections()
        prevConnections.append(connection)
        let data = prevConnections.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: keyForConnectionStorage)
        self.connections = getConnections()
        DSPNotification().update(object: self)
    }
    
    // MARK: Get Connections List
    func getConnections() -> [InitialConnection] {
        guard let encodedData = UserDefaults.standard.array(forKey: keyForConnectionStorage) as? [Data] else { return [] }
        return encodedData.map { try! JSONDecoder().decode(InitialConnection.self, from: $0)}
    }
    
    // MARK: Get Coordinate to Connect
    func getCoordinates(id: UUID) -> CGPoint {
        if let object = ObjectManager().getObject(id: id) {
            return object.currentPosition
        } else {
            return CGPoint(x: 0, y: 0)
        }
        
    }
}
