//
//  ObjectManager.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import Foundation
import SwiftUI

class ObjectManager: ObservableObject {
    
    let keyForUserDefaults = "DSPObjects"
    
    @Published var fileDetail:Dictionary<String, String> = ["status": "none"]
    @Published var workspaceObjects = [DSPObject]()

    @AppStorage("workspaceObjects") var workspaceObjectsStorage: Data?
    
    init() {
        self.workspaceObjects = getObjects()
    }
    

    
    // MARK: Save Obejcts
    func saveObject(_ DSPObject: DSPObject) {
        var prevData = getObjects()
        prevData.append(DSPObject)
        let data = prevData.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: keyForUserDefaults)
        self.workspaceObjects = getObjects()
        DSPNotification().update(object: self)
    }
    
    func saveObject(_ DSPObjects: [DSPObject]) {
        let data = DSPObjects.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: keyForUserDefaults)
        self.workspaceObjects = getObjects()
        DSPNotification().update(object: self)
    }
    
    // MARK: Update Object Name
    func updateName(of objID: UUID, to objName: String, position: CGPoint) {
        let prevData = getObjects()
        var newData = [DSPObject]()
        var newOBJ: DSPObject
        for item in prevData {
            if item.id == objID {
                newOBJ = DSPObject(id: objID, type: item.type, title: objName, currentPosition: position)
                newData.append(newOBJ)
                AudioModelManager().updateObjectID(newID: newOBJ.id, oldID: objID)
            } else {
                newData.append(item)
            }
        }
        
        saveObject(newData)
    }
    
    // MARK: Delete One
    func deleteObject(of objID: UUID) {
        let prevData = getObjects()
        var newData = [DSPObject]()
        
        for item in prevData {
            if item.id != objID {
                newData.append(item)
            }
        }
        saveObject(newData)
    }
    
    // MARK: Get Objects
    func getObjects() -> [DSPObject] {
        guard let encodedData = UserDefaults.standard.array(forKey: keyForUserDefaults) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(DSPObject.self, from: $0) }
    }
    
    // MARK: Get One Object
    func getObject(id: UUID) -> DSPObject? {
        let data = getObjects()
        if let res = data.filter({ $0.id == id }).first {
            return res
        } else {
            return nil
        }
    }
    func getIDS() -> [UUID] {
        let data = getObjects()
        var allIDs = [UUID]()
        for objs in data {
            allIDs.append(objs.id)
        }
        
        return allIDs
    }
    
    
    // MARK: Delete All
    func deleteAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            self.workspaceObjects.removeAll()
            DSPNotification().update(object: self)
        }
    }
    
    func updatePosition(dspObject: DSPObject, to newPosition: CGPoint) {
        let prevData = getObjects()
        var newData = [DSPObject]()
        
        for item in prevData {
            if item.id == dspObject.id {
                newData.append(DSPObject(id: dspObject.id, type: dspObject.type, title: item.title, currentPosition: newPosition))
            } else {
                newData.append(item)
            }
        }
        saveObject(newData)
    }

    
    func objectArrayToData(from objectsArray: [String]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: objectsArray, options: [])
    }
    
    func dataToObjectArray(from data: Data) -> [String]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String]
    }
}
