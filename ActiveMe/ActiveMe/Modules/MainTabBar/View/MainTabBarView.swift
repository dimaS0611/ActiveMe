//
//  MainTabBarView.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 4.12.21.
//

import Foundation
import UIKit

class MainTabBarView: UITabBarController {
    
    override func viewDidLoad() {
        self.tabBar.backgroundColor = .systemGray6
        
        let homeItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill")?.withTintColor(UIColor(rgb: 0x178FB3)))
        let homeVC = HomeView()
        
        homeVC.tabBarItem = homeItem
        
        let activityItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "chart.bar.xaxis")!, selectedImage: UIImage(systemName: "chart.bar.xaxis")!.withTintColor(UIColor(rgb: 0x178FB3)))
        let activityVC = ActivityView()
        
        activityVC.tabBarItem = activityItem
        
        let settingsItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), selectedImage: UIImage(systemName: "gearshape.fill")?.withTintColor(UIColor(rgb: 0x178FB3)))
        let settingsVC = SettingsView()
        
        settingsVC.tabBarItem = settingsItem
        
        self.setViewControllers([homeVC, activityVC, settingsVC], animated: false)
    }
    
}
