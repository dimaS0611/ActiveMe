//
//  ViewController.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let slider = StrokesSlider(cellsRange: Range(140...210))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addCollection()
    }
    
    func addCollection() {
        view.addSubview(slider)
        
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200.0)
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let layoutMargins: CGFloat = slider.collectionView.layoutMargins.left + slider.collectionView.layoutMargins.right
        let sideInset = (self.view.frame.width / 2) - layoutMargins
        
        slider.collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset,
                                                        bottom: 0, right: sideInset)
    }


}

