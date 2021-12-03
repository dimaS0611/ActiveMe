//
//  WaterBalanceListView.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/3/21.
//

import Foundation
import UIKit

class WaterBalanceListView: UIViewController {    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>! = nil
    private var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add a drink"
        configureHieratchy()
        configureDataSource()
    }
    
    private var appearance = UICollectionLayoutListConfiguration.Appearance.insetGrouped
}

extension WaterBalanceListView {
    private func configureHieratchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: self.appearance)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
}

extension WaterBalanceListView {
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            //cell.accessories = [.outlineDisclosure()]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.emojiIcon
            cell.contentConfiguration = content
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        let sections = WaterBalanceListModel().configureSections()
        snapshot.appendSections(Array(0...5))
        dataSource.apply(snapshot, animatingDifferences: true)
        
        for section in 0..<sections.count {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            let headerItem = sections[section].header
            sectionSnapshot.append([headerItem])
            let items = sections[section].items
            sectionSnapshot.append(items, to: headerItem)
            sectionSnapshot.expand([headerItem])
            dataSource.apply(sectionSnapshot, to: section)
        }
    }
}
