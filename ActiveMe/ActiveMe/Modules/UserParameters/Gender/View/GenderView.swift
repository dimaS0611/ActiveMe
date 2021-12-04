//
//  ViewController.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension GenderView {
    struct Appearance {
        let appIcon: UIImage = UIImage(named: "ActiveMeName")!
    }
}

class GenderView: UIViewController {

    private  let disposeBag = DisposeBag()
    
    var viewModel: GenderViewModelProtocol? = nil
    
    private let slider = StrokesSlider(cellsRange: Range(140...210))
    
    private let femaleButton: GenderButton = {
        return GenderButton(gender: .Female)
     }()
    
    private let maleButton: GenderButton = {
        return GenderButton(gender: .Male)
     }()
    
    private let otherButton: GenderButton = {
       return GenderButton(gender: .Other)
    }()
    
    private let nextButton: NextButton = {
       return NextButton(frame: CGRect(x: 0, y: 0, width: 85.0, height: 85.0))
    }()
    
    private lazy var questionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.bold(with: 35.0)
        label.textColor = .label
        label.text = "Tell us your gender"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var appIcon: UIImageView = {
       let imageView = UIImageView()
    return imageView
    }()
    
    private let appearance = Appearance()
    private var safeArea: UILayoutGuide?
    
    private var selectedGender: Gender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationController?.isNavigationBarHidden = true
        safeArea = view.safeAreaLayoutGuide
        
        appIcon.image = appearance.appIcon
        
        femaleButton.delegate = self
        maleButton.delegate = self
        otherButton.delegate = self
        
        nextButton.delegate = self
        
        setupUI()
    }
    
    func setupUI() {        
        view.addSubview(femaleButton)
        view.addSubview(maleButton)
        view.addSubview(otherButton)
        view.addSubview(questionLabel)
        view.addSubview(appIcon)
        view.addSubview(nextButton)
        
        femaleButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(nextButton.snp.top).inset(-100.0)
            make.width.height.equalTo(150.0)
            make.leading.lessThanOrEqualToSuperview().offset(20.0)
        }
        
        maleButton.snp.makeConstraints { make in
            make.bottom.equalTo(femaleButton.snp.bottom)
            make.width.height.equalTo(150.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-20.0)
        }
        
        otherButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(maleButton.snp.top).offset(-20.0)
            make.width.height.equalTo(150.0)
        }
        
        appIcon.snp.makeConstraints { make in
            make.width.equalTo(100.0)
            make.height.equalTo(70.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(35.0)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appIcon.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview().inset(35.0)
            make.height.equalTo(50.0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(60.0)
            make.height.width.equalTo(85.0)
            make.centerX.equalToSuperview()
        }
    }
}

extension GenderView: GenderButtonDelegate {
    func buttonSelected(gender: Gender) {
        self.selectedGender = gender
        switch gender {
        case .Male:
            femaleButton.isUserInteractionEnabled = false
            otherButton.isUserInteractionEnabled = false
        case .Female:
            maleButton.isUserInteractionEnabled = false
            otherButton.isUserInteractionEnabled = false
        case .Other:
            femaleButton.isUserInteractionEnabled = false
            maleButton.isUserInteractionEnabled = false
        }
    }
    
    func buttonDeselected(gender: Gender) {
        self.selectedGender = nil
        switch gender {
        case .Male:
            femaleButton.isUserInteractionEnabled = true
            otherButton.isUserInteractionEnabled = true
        case .Female:
            maleButton.isUserInteractionEnabled = true
            otherButton.isUserInteractionEnabled = true
        case .Other:
            femaleButton.isUserInteractionEnabled = true
            maleButton.isUserInteractionEnabled = true
        }
    }
}

extension GenderView: NextButtonDelegate {
    func nextButtonTapped() {
        guard let gender = self.selectedGender else { return }
        self.viewModel?.chooseGender.onNext(gender)
    }
}


