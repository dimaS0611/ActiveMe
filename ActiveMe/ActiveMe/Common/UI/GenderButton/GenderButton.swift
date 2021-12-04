//
//  GenderButton.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 28.11.21.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol GenderButtonDelegate: AnyObject {
    func buttonSelected(gender: Gender)
    func buttonDeselected(gender: Gender)
}

enum Gender: String {
    case Male
    case Female
    case Other
}

extension GenderButton {
    struct Appearance {
        let maleFillIcon: UIImage = UIImage(named: "male.fill")!
        let maleIcon: UIImage = UIImage(named: "male")!
        let femaleFillIcon: UIImage = UIImage(named: "female.fill")!
        let femaleIcon: UIImage = UIImage(named: "female")!
        let otherIcon: UIImage = UIImage(named: "other")!
        let otherFillIcon: UIImage = UIImage(named: "other.fill")!
        
        let borderColor: UIColor = UIColor.lightGray
        let selectedBorderColor: UIColor = UIColor(rgb: 0xea5975)
        
        let borderWidth: CGFloat = 2.0
    }
}

class GenderButton: UIView {
    
    private let disposeBag = DisposeBag()
    
    weak var delegate: GenderButtonDelegate?
    
    // MARK: - Appearance
    
    private let appearance = Appearance()
    
    var buttonSelected: Bool = false
    
    // MARK: - View model
    
    var gender: Gender = .Female
    
    // MARK: - UI properties
    
    private let genderImageView: UIImageView = {
        return UIImageView(frame: .zero)
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.bold(with: 16.0)
        label.numberOfLines = 1
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let genderSubtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.regular(with: 13.0)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    init(gender: Gender) {
        super.init(frame: .zero)
        self.gender = gender
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
        setupContent()
        setupEvent()
    }

    // MARK: - View config
    
    private func setupUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 4
        self.layer.borderColor = appearance.borderColor.cgColor
        self.layer.borderWidth = appearance.borderWidth
        
        addSubviews()
        setupConstraints()
        setupContent()
    }
    
    private func addSubviews() {
        addSubview(genderImageView)
        addSubview(genderLabel)
        addSubview(genderSubtitleLabel)
    }
    
    private func setupConstraints() {
        genderImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10.0)
            make.width.height.lessThanOrEqualTo(50.0)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(genderImageView.snp.bottom).offset(10.0)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(100.0)
            make.height.equalTo(15.0)
        }
        
        genderSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(5.0)
            make.bottom.equalToSuperview().offset(5.0)
        }
    }
    
    /// setting up button's content, based on gender value
    private func setupContent() {
        switch gender {
        case .Male:
            self.genderImageView.image = appearance.maleIcon
        case .Female:
            self.genderImageView.image = appearance.femaleIcon
        case .Other:
            self.genderImageView.image = appearance.otherIcon
        }
        
        genderLabel.text = gender.rawValue
        genderSubtitleLabel.text = "You are planing to use our platform as \(gender.rawValue) ?"
    }
    
    private func setupEvent() {
        
        let tap = UITapGestureRecognizer()
        
        self.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe { [weak self] _ in
            guard let selected = self?.buttonSelected,
                  let gender = self?.gender else { return }
            if !selected {
                self?.selectButton()
                self?.delegate?.buttonSelected(gender: gender)
            } else {
                self?.deseletButton()
                self?.delegate?.buttonDeselected(gender: gender)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func selectButton() {
        switch gender {
        case .Male:
            self.genderImageView.image = appearance.maleFillIcon
        case .Female:
            self.genderImageView.image = appearance.femaleFillIcon
        case .Other:
            self.genderImageView.image = appearance.otherFillIcon
        }
        
        self.layer.borderColor = appearance.selectedBorderColor.cgColor
        
        self.buttonSelected.toggle()
    }
    
    func deseletButton() {
        switch gender {
        case .Male:
            self.genderImageView.image = appearance.maleIcon
        case .Female:
            self.genderImageView.image = appearance.femaleIcon
        case .Other:
            self.genderImageView.image = appearance.otherIcon
        }
        
        self.layer.borderColor = appearance.borderColor.cgColor
        
        self.buttonSelected.toggle()
    }
}

extension GenderButton {
}
