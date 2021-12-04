//
//  NextButton.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 3.12.21.
//

import Foundation
import UIKit
import RxSwift

protocol NextButtonDelegate: AnyObject {
    func nextButtonTapped()
}

extension NextButton {
    struct Appearance {
        let arrowImage: UIImage = UIImage(named: "arrow")!
        let background: UIColor = UIColor(rgb: 0x178FB3)
    }
}

class NextButton: UIView {
    
    private let appearance = Appearance()
    
    private let disposeBag = DisposeBag()
    
    private lazy var arrowImageView: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    weak var delegate: NextButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupEvent()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.cornerRadius = self.bounds.size.width * 0.5
        self.clipsToBounds = true
        self.backgroundColor = appearance.background
        
        addSubview(arrowImageView)
        
        arrowImageView.image = appearance.arrowImage
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.arrowImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(5.0)
        }
    }
    
    private func setupEvent() {
        let tap = UITapGestureRecognizer()
        
        self.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe { [weak self] _ in
            self?.delegate?.nextButtonTapped()
        }.disposed(by: self.disposeBag)
    }
}
