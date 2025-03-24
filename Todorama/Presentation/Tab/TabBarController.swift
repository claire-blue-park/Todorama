//
//  TabBarController.swift
//  Todorama
//
//  Created by 권우석 on 3/23/25.
//

import UIKit


final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        setupTabBarAppearance()
    }
    
    private func configureTabBarController() {
        // 홈 탭
        let homeVC = HomeViewController()
        homeVC.tabBarItem.image = UIImage(systemName: SystemImages.tab.houseICON.name)
        homeVC.tabBarItem.title = Strings.TabBarTitle.houseTab.name
        
        // 검색 탭
        let searchVC = SearchViewController()
        searchVC.tabBarItem.image = UIImage(systemName: SystemImages.tab.magnifICON.name)
        searchVC.tabBarItem.title = Strings.TabBarTitle.searchTab.name
        
        // 보관함 탭
        let archiveVC = ArchiveViewController()
        archiveVC.tabBarItem.image = UIImage(systemName: SystemImages.tab.archiveICON.name)
        archiveVC.tabBarItem.title = Strings.TabBarTitle.archiveTab.name
        
        // 네비게이션 컨트롤러 구성
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let archiveNav = UINavigationController(rootViewController: archiveVC)
        
        // 탭바 컨트롤러에 뷰 컨트롤러 설정
        setViewControllers([homeNav, searchNav, archiveNav], animated: true)
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .tdBlack
        
        appearance.stackedLayoutAppearance.normal.iconColor = .tdGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.tdGray]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .tdMain
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor : UIColor.tdMain]
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.shadowRadius = 0
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.3
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .tdMain
    }
}
