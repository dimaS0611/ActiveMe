//
//  StrokesSliderCell.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import Foundation
import UIKit
import SnapKit

class StrokesSliderCell: UICollectionViewCell {
    
    private var title: String =  ""
    private var cellValue: Int = 0
    
    // MARK: - UI properties
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.regular(with: 12)
        label.textAlignment = .center
        return label
    }()
    
    lazy var stroke: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(label)
        addSubview(stroke)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(35.0)
            make.top.equalToSuperview().offset(20.0)
        }
        
        stroke.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(20.0)
            make.bottom.equalToSuperview()
            make.width.equalTo(3.0)
        }
    }
}

// MARK: - StrokeSliderCellProtocol implementation

extension StrokesSliderCell: StrokeSliderCellProtocol {
    
    func setTitle(title: Int) {
        self.label.text = String(title)
        self.cellValue = title
    }
    
    func setActiveCell() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.stroke.backgroundColor = .black
            self.label.font = UIFont.medium(with: 14)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    func setInactiveCell() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = 0
            self.transform = CGAffineTransform.identity
            
            self.stroke.backgroundColor = .lightGray
            self.label.font = UIFont.regular(with: 12)
        }
    }
    
    func getValueOfCell() -> Int {
        self.cellValue
    }
}
