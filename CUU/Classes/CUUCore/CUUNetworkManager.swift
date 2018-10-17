//
//  CUUNetworkManager.swift
//  CUU
//
//  Created by Lara Marie Reimer on 16.10.18.
//

import Foundation

public class CUUNetworkManager {
    
    static public let shared = CUUNetworkManager()
    
    var timer : Timer? = nil
    
    var lastFetchDate : Date? {
        get {
            return UserDefaults.standard.object(forKey: CUUConstants.CUUUserDefaultsKeys.lastFetchDateKey) as? Date
        }
    }
    
    public func start() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.timerDidFire), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerDidFire(sender: Timer) {
        // First, get all data from the databases.
        var predicate : NSPredicate? = nil
        if let lastFetchDate = lastFetchDate {
            predicate = NSPredicate(format: "startDate > %@", lastFetchDate as CVarArg)
        }
        var networkObjects : [CUUNetworkObject] = []
        
        let currentTimestamp = Date()
        
        let dispatchGroup: DispatchGroup = DispatchGroup.init()
        
        dispatchGroup.enter()
        InteractionKit.shared.fetch(IKInteraction.self, predicate: predicate, completion: { results in
            
            let processedObjects = results.map({ (interaction) -> CUUNetworkObject? in
                // Try to serialize interaction data.
                
                do {
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .iso8601
                    let json = try encoder.encode(interaction)
                    let networkObject = CUUNetworkObject.init(type: CUUConstants.CrumbTypes.interactionCrumb, payload: json)
                    return networkObject
                } catch _ {
                    print ("Error serializing interaction")
                    return nil
                }
            }).filter({ (networkObject) -> Bool in
                return (networkObject != nil)
            }).map({ $0! })
            
            networkObjects.append(contentsOf: processedObjects)
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            // Send the request.
            networkObjects.send { (succeeded) in
                // Reset the date for the last fetch.
                UserDefaults.standard.set(currentTimestamp, forKey: CUUConstants.CUUUserDefaultsKeys.lastFetchDateKey)
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
