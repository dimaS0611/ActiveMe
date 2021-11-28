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

extension UserParametersView {
    struct Appearance {
        let appIcon: UIImage = UIImage(named: "ActiveMeName")!
    }
}

class UserParametersView: UIViewController {

    let disposeBag = DisposeBag()
    
    let slider = StrokesSlider(cellsRange: Range(140...210))
    
    let femaleButton = GenderButton(gender: .Female)
    let maleButton = GenderButton(gender: .Male)
    let otherButton = GenderButton(gender: .Other)
    
    lazy var questiionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.bold(with: 35.0)
        label.textColor = .black
        label.text = "Tell us your gender"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    lazy var appIcon: UIImageView = {
       let imageView = UIImageView()
    return imageView
    }()
    
    private let appearance = Appearance()
    private var safeArea: UILayoutGuide?
    
    
    var viewModel: UserParametersViewModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        safeArea = view.safeAreaLayoutGuide
        
        appIcon.image = appearance.appIcon
        
        setupUI()
    }
    
    func setupUI() {
        //view.addSubview(slider)
        guard let safeArea = safeArea else {
            return
        }
        
        view.addSubview(femaleButton)
        view.addSubview(maleButton)
        view.addSubview(otherButton)
        view.addSubview(questiionLabel)
        view.addSubview(appIcon)
        
        femaleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(170.0)
            make.leading.lessThanOrEqualToSuperview().offset(20.0)
        }
        
        maleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(170.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-20.0)
        }
        
        otherButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(maleButton.snp.bottom).offset(20.0)
            make.width.height.equalTo(170.0)
        }
        
        appIcon.snp.makeConstraints { make in
            make.width.equalTo(100.0)
            make.height.equalTo(70.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(safeArea.snp.top)
        }
        
        questiionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appIcon.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview().inset(35.0)
            make.height.equalTo(140.0)
        }
        
        
//        slider.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(200.0)
//            make.center.equalToSuperview()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let layoutMargins: CGFloat = slider.collectionView.layoutMargins.left + slider.collectionView.layoutMargins.right
//        let sideInset = (self.view.frame.width / 2) - layoutMargins
//
//        slider.collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset,
//                                                        bottom: 0, right: sideInset)
//
//        slider.snapToCenter()
    }
}


