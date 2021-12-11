//
//  HeightView.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 3.12.21.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

enum SliderQuestionType: String {
    case height = "height"
    case age = "age"
    case weight = "weight"
}

extension SliderParametersView {
    struct Appearance {
        let appIcon: UIImage = UIImage(named: "ActiveMeName")!
    }
}

class SliderParametersView: UIViewController {
    
    var question: String
    
    var type: SliderQuestionType
    
    var sliderRange: Range<Int>
    
    var sliderValue: Int?
    
    private let appearance = Appearance()
    
    private let disposeBag = DisposeBag()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold(with: 35.0)
        label.textColor = .label
        label.text = question
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var appIcon: UIImageView = {
       return UIImageView()
    }()
    
    private let nextButton: NextButton = {
       return NextButton(frame: CGRect(x: 0, y: 0, width: 85.0, height: 85.0))
    }()
    
    private lazy var slider: StrokesSlider = {
        return StrokesSlider(cellsRange: self.sliderRange)
    }()
    
    var viewModel: SliderParametersViewModelProtocol?
    
    init(question: String, type: SliderQuestionType, sliderRange: Range<Int>) {
        self.question = question
        self.sliderRange = sliderRange
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.nextButton.delegate = self

        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemGray6
        
        view.addSubview(slider)
        view.addSubview(questionLabel)
        view.addSubview(appIcon)
        view.addSubview(nextButton)
        
        questionLabel.text = question
        appIcon.image = appearance.appIcon
        
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
        
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200.0)
            make.center.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(60.0)
            make.height.width.equalTo(85.0)
            make.centerX.equalToSuperview()
        }
        
        slider.snapToCenter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let layoutMargins: CGFloat = slider.collectionView.layoutMargins.left + slider.collectionView.layoutMargins.right
        let sideInset = (self.view.frame.width / 2) - layoutMargins
        
        slider.collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset,
                                                          bottom: 0, right: sideInset)
        
//        slider.snapToCenter()
    }
}

extension SliderParametersView: NextButtonDelegate {
    func nextButtonTapped() {
        guard let value = self.slider.getSelectedValue() else { return }
        self.viewModel?.chooseValue.onNext((value, self.type))
    }
}
