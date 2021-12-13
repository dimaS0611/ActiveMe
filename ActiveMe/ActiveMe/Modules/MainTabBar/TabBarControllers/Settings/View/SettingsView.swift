//
//  SettingsView.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 4.12.21.
//

import Foundation
import UIKit
import Photos
import RxCocoa
import RxSwift

class SettingsView: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: SettingsViewModelProtocol = SettingsViewModel()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150.0, height: 150.0))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.image = UIImage(named: "ActiveMeLogoMen")
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40.0))
        textField.contentMode = .left
        textField.clearsOnInsertion = true
        textField.font = UIFont.regular(with: 15.0)
        textField.placeholder = "Name"
        textField.returnKeyType = .done
        textField.minimumFontSize = 12.0
        textField.textColor = .secondaryLabel
        return textField
    }()
    
    private lazy var ageTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40.0))
        textField.contentMode = .left
        textField.clearsOnInsertion = true
        textField.font = UIFont.regular(with: 15.0)
        textField.placeholder = "Age"
        textField.returnKeyType = .done
        textField.minimumFontSize = 12.0
        textField.textColor = .secondaryLabel
        return textField
    }()
    
    private lazy var heightTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: 40.0))
        textField.contentMode = .left
        textField.clearsOnInsertion = true
        textField.font = UIFont.regular(with: 15.0)
        textField.placeholder = "Height"
        textField.returnKeyType = .done
        textField.minimumFontSize = 12.0
        textField.textColor = .secondaryLabel
        return textField
    }()
    
    private lazy var weightTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: 40.0))
        textField.contentMode = .left
        textField.clearsOnInsertion = true
        textField.font = UIFont.regular(with: 15.0)
        textField.placeholder = "Weight"
        textField.returnKeyType = .done
        textField.minimumFontSize = 12.0
        textField.textColor = .secondaryLabel
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(rgb: 0x178FB3)
        button.layer.cornerRadius = 15.0
        button.clipsToBounds = true
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.thin(with: 20.0)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray6
        
        nameTextField.delegate = self
        ageTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        setupUI()
        setupEvents()
        
        let settingsModel = viewModel.loadSettingsData()
        
        nameTextField.text = settingsModel.name
        ageTextField.text = String(settingsModel.age)
        weightTextField.text = String(settingsModel.weight)
        heightTextField.text = String(settingsModel.height)
        
        if let image = settingsModel.imageData {
            let img = UIImage(data: image)
            avatarImage.image = img
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        decorateTextFields()
    }
    
    private func setupUI() {
        view.addSubview(avatarImage)
        
        view.addSubview(nameTextField)
        view.addSubview(ageTextField)
        view.addSubview(heightTextField)
        view.addSubview(weightTextField)
        
        view.addSubview(saveButton)
        
        avatarImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15.0)
            make.width.height.lessThanOrEqualTo(150.0)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25.0)
            make.height.greaterThanOrEqualTo(40.0)
            make.top.equalTo(avatarImage.snp.bottom).inset(-25.0)
        }

        ageTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25.0)
            make.height.greaterThanOrEqualTo(40.0)
            make.top.equalTo(nameTextField.snp.bottom).inset(-25.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(35.0)
            make.height.equalTo(45.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(35.0)
        }
        
        heightTextField.snp.makeConstraints { make in
            make.leading.equalTo(nameTextField.snp.leading)
            make.width.equalTo(UIScreen.main.bounds.width / 2.1)
            make.height.equalTo(ageTextField.snp.height)
            make.top.equalTo(ageTextField.snp.bottom).inset(-15.0)
        }

        weightTextField.snp.makeConstraints { make in
            make.leading.equalTo(heightTextField.snp.trailing).inset(-5.0)
            make.trailing.equalToSuperview().inset(15.0)
            make.height.equalTo(nameTextField.snp.height)
            make.top.equalTo(heightTextField.snp.top)
        }
        
        avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2.0
    }
    
    
    private func decorateTextFields() {
        nameTextField.addBottomBorder()
        ageTextField.addBottomBorder()
        heightTextField.addBottomBorder()
        weightTextField.addBottomBorder()
    }

    private func setupEvents() {
        let tap = UITapGestureRecognizer()
        avatarImage.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe { [weak self] _ in
            self?.showAlert()
        }.disposed(by: self.disposeBag)
        
        saveButton.rx.tap.subscribe { [weak self] _ in
            self?.saveButtonTapped()
        }.disposed(by: self.disposeBag)
    }
    
    private func saveButtonTapped() {
        guard let name = nameTextField.text,
              !name.isEmpty,
              let ageStr = ageTextField.text,
              !ageStr.isEmpty,
              let age = Int(ageStr),
              let weightStr = weightTextField.text,
              !weightStr.isEmpty,
              let weight = Int(weightStr),
              let heightStr = heightTextField.text,
              !heightStr.isEmpty,
              let height = Int(heightStr)
        else {
            return
        }
        
        let imageData = avatarImage.image?.pngData()
        
        viewModel.saveButtonTapped(model: SettingsModel(name: name, age: age, height: height, weight: weight, imageData: imageData))
    }
    
    private func showAlert() {
        let alertView = UIAlertController(title: "Choose source type",
                                          message: "",
                                          preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.imagePicker.cameraAsscessRequest()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery",
                                          style: .default) { [weak self] _ in
            self?.imagePicker.photoGalleryAsscessRequest()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { [weak self] _ in
            alertView.dismiss(animated: true, completion: nil)
            return
        }
        
        alertView.addAction(cameraAction)
        alertView.addAction(galleryAction)
        alertView.addAction(cancelAction)
        
        present(alertView, animated: true, completion: nil)
    }

    
}

// MARK: UITextFieldDelegate implementation

extension SettingsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let ch = string.first else {
            return true
        }
        
        switch textField {
        case nameTextField:
            if textField.text?.count == 40 {
                return false
            }
            if ch.isLetter {
                return true
            }
            return false
        case ageTextField:
            if textField.text?.count == 3 {
                return false
            }
            if ch.isNumber {
                return true
            }
            return false
        case heightTextField:
            if textField.text?.count == 3 {
                return false
            }
            if ch.isNumber {
                return true
            }
            return false
        case weightTextField:
            if textField.text?.count == 3 {
                return false
            }
            if ch.isNumber {
                return true
            }
            return false
        default:
            return false
        }
    }
}

// MARK: ImagePickerDelegate implementation

extension SettingsView: ImagePickerDelegate {

    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        avatarImage.image = image
        imagePicker.dismiss()
    }

    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
