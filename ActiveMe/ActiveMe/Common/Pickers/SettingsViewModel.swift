//
//  SettingsViewModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/13/21.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
    func saveButtonTapped(model: SettingsModel)
    func loadSettingsData() -> SettingsModel
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    init() {
        
    }
    
    func saveButtonTapped(model: SettingsModel) {
        UserDefaultsManager.saveObject(for: .ageValue, value: model.age)
        UserDefaultsManager.saveObject(for: .heightValue, value: model.height)
        UserDefaultsManager.saveObject(for: .weightValue, value: model.weight)
        UserDefaultsManager.saveObject(for: .name, value: model.name)
        if let image = model.imageData {
            UserDefaultsManager.saveObject(for: .avatar, value: image)
        }
    }
    
    func loadSettingsData() -> SettingsModel {
        guard let name = UserDefaultsManager.getStringObject(for: .name),
              let age = UserDefaultsManager.getIntObject(for: .ageValue),
              let height = UserDefaultsManager.getIntObject(for: .heightValue),
              let weihgt = UserDefaultsManager.getIntObject(for: .weightValue)
        else {
            return SettingsModel(name: "",
                                 age: 0,
                                 height: 0,
                                 weight: 0,
                                 imageData: nil)
        }
        
        let imageData = UserDefaultsManager.getDataObject(for: .avatar)
        return SettingsModel(name: name,
                             age: age,
                             height: height,
                             weight: weihgt,
                             imageData: imageData)
    }
}
