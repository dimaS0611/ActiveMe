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
    static func getStringObject(for key: UserDefaultsKeys) -> String?
    static func getIntObject(for key: UserDefaultsKeys) -> Int?
    static func getDoubleObject(for key: UserDefaultsKeys) -> Double?
    static func getBoolObject(for key: UserDefaultsKeys) -> Bool?
    static func getDataObject(for key: UserDefaultsKeys) -> Data?
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
    
    static func getStringObject(for key: UserDefaultsKeys) -> String? {
        do {
            if let data = defaults.data(forKey: key.rawValue) {
                guard let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? String else {
                    return nil
                }
                return decoded
            } else {
                return nil
            }
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getIntObject(for key: UserDefaultsKeys) -> Int? {
        do {
            if let data = defaults.data(forKey: key.rawValue) {
                guard let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Int else {
                    return nil
                }
                return decoded
            } else {
                return nil
            }
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getDoubleObject(for key: UserDefaultsKeys) -> Double? {
        do {
            if let data = defaults.data(forKey: key.rawValue) {
                guard let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Double else {
                    return nil
                }
                return decoded
            } else {
                return nil
            }
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getBoolObject(for key: UserDefaultsKeys) -> Bool? {
        do {
            if let data = defaults.data(forKey: key.rawValue) {
                guard let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Bool else {
                    return false
                }
                return decoded
            } else {
                return nil
            }
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getDataObject(for key: UserDefaultsKeys) -> Data? {
        if let data = defaults.data(forKey: key.rawValue) {
            return data
        } else {
            return nil
        }
    }
    
    static func getRegisterData() -> Bool {
        do {
            if let isRegistered = defaults.object(forKey: UserDefaultsKeys.isRegistered.rawValue) as? Data {
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
