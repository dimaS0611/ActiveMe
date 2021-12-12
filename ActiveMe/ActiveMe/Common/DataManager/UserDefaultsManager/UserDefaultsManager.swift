//
//  UserDefaultsManager.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 11.12.21.
//

import Foundation

protocol UserDefaultsManagerProtocol: AnyObject {
    static func saveObject<T: Any>(for key: UserDefaultsKeys, value: T)
    static func getObject(for key: UserDefaultsKeys) -> Any?
    static func getRegisterData() -> Bool
}

class UserDefaultsManager {
    private static let defaults = UserDefaults.standard
}

extension UserDefaultsManager: UserDefaultsManagerProtocol {
    static func saveObject<T>(for key: UserDefaultsKeys, value: T) where T : Any {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: key.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func getObject(for key: UserDefaultsKeys) -> Any? {
        defaults.object(forKey:key.rawValue)
    }
    
    static func getRegisterData() -> Bool {
        do {
            if let isRegistered = defaults.object(forKey:UserDefaultsKeys.isRegistered.rawValue) as? Data {
                guard let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(isRegistered) as? Bool else {
                    return false
                }
                return decoded
            } else {
                return false
            }
        } catch let error{
            print(error.localizedDescription)
            return false
        }
    }
}
