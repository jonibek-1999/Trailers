//
//  MainTabBarVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/07/22.
//

import UIKit

final class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: SearchVC())
        let vc3 = UINavigationController(rootViewController: UpcomingVC())
        let vc4 = UINavigationController(rootViewController: DownloadVC())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "play.circle")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Coming Soon"
        vc4.title = "Downloads"

        tabBar.tintColor = Color.buttonColor
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}

