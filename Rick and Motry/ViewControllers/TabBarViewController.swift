//
//  TabBarViewController.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 7.12.23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let episodesVC = EpisodesViewController()
        let favouritesVC = FavouritesViewController()
        
        //Add tabBarItems
        episodesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "selectedHomeTabIcon"), tag: 0)
        favouritesVC.tabBarItem =  UITabBarItem(title: nil, image: UIImage(named: "selectedHeartTabIcon"), tag: 1)
        
        //TabBar appearance
        tabBar.unselectedItemTintColor = ButtonAppearance.tabBarItemTintColor
        tabBar.tintColor = ButtonAppearance.fillTabBarItemColor
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 2, height: 2)
        tabBar.layer.shadowOpacity = 0.7
        
        //Root vc for nacControllers
        let navEpisodesVC = UINavigationController(rootViewController: episodesVC)
        let navFavouritesVC = UINavigationController(rootViewController: favouritesVC)
        
        self.setViewControllers([navEpisodesVC, navFavouritesVC], animated: false)
    }
    
    //MARK: Add spacing between tabBarItems
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 40
    }
}
