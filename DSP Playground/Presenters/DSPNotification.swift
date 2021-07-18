//
//  NotificationCenter.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/18.
//

import Foundation

class DSPNotification {
    let ncKEY = Notification.Name("specialNotificationKey")
    let nc = NotificationCenter.default
    
    func publisher() -> NotificationCenter.Publisher {
        return nc.publisher(for: ncKEY)
    }
    
    func update(object: Any?) {
        nc.post(name: ncKEY, object: object)
    }
    
    
    let ncPathKey = Notification.Name("specialNotificationKey")
    let ncPath = NotificationCenter.default
    
    func publisherPath() -> NotificationCenter.Publisher {
        return ncPath.publisher(for: ncPathKey)
    }
    
    func updatePath(object: Any?) {
        nc.post(name: ncPathKey, object: object)
    }

}
