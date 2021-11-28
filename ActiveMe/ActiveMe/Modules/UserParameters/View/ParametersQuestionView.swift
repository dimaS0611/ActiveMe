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

class UserParametersView: UIViewController {

    let disposeBag = DisposeBag()
    
    let slider = StrokesSlider(cellsRange: Range(140...210))
    let genderButton = GenderButton(gender: .Female)
    
    var viewModel: UserParametersViewModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addCollection()
    }
    
    func addCollection() {
        //view.addSubview(slider)
        view.addSubview(genderButton)
        
        genderButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(150.0)
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


