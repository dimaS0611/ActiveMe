//
//  StrokesSlider.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import Foundation
import UIKit
import SnapKit

class StrokesSlider: UIView {
    
    // MARK: - DataSource
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, StrokeCell>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, StrokeCell>
    
    private var section = [Section]()
    private var cells = [StrokeCell]()
    
    private lazy var dataSource = makeDataSource()
    private var cellsRange: Range<Int> = Range(0...0)
    
    // MARK: - UI properties
    
    let collectionViewFlowLayout = StrokesSliderFlowLayout()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StrokesSliderCell.self, forCellWithReuseIdentifier: StrokesSliderCell.reuseIdentifier)
        return collectionView
    }()
    
    private var centerCell: StrokeSliderCellProtocol? = nil
    
    // MARK: - Init
    
    init(cellsRange: Range<Int>) {
        super.init(frame: .zero)
        
        self.cellsRange = cellsRange
        
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup datasource
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StrokesSliderCell.reuseIdentifier, for: indexPath) as? StrokesSliderCell
                cell?.setTitle(title: itemIdentifier.title)
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(section)
        section.forEach { section in
            snapshot.appendItems(section.cells, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        
        self.collectionViewFlowLayout.itemSize = CGSize(width: 50.0, height: self.frame.height)
        self.collectionView.collectionViewLayout = collectionViewFlowLayout
        
        for i in cellsRange {
            cells.append(StrokeCell(titile: i))
        }
        section.append(Section(cells: cells))
        
        applySnapshot()
    }

    // MARK: - ScrollView delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        
        let centerPoint = CGPoint(x: self.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: self.collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
        
        if let indexPath = self.collectionView.indexPathForItem(at: centerPoint),
           self.centerCell == nil
        {
            self.centerCell = collectionView.cellForItem(at: indexPath) as? StrokesSliderCell
            self.centerCell?.setActiveCell()
        }
        if let centerCell = centerCell as? StrokesSliderCell {
            let offsetX = centerPoint.x - centerCell.center.x
            
            if offsetX < -15 || offsetX > 15 {
                centerCell.setInactiveCell()
                self.centerCell = nil
            }
        }
    }
}


// MARK: - UICollectionViewDelegate implementation

extension StrokesSlider: UICollectionViewDelegate {
    
}

extension StrokesSlider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = (50 / 4) * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)

        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
