//
//  Router.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/10.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit

class Router {
    
    static let shared = Router()
    
    //Mark: init
    private init() {}
    
    public func goTo() {
        let token = UserDefaults.standard.object(forKey: "accessToken")
        AppDelegate.shareDelegate().window?.rootViewController = token == nil ? gotoLoginPage() : gotoMainPage()
    }
    
    private func gotoMainPage() -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let playlistVC: PlayListViewController = sb.instantiateVC()
        let favoriteVC: FavoriteViewController = sb.instantiateVC()
        let logoutVC = LogoutViewController(vm: LogoutViewModel())
        
        let playlistNImage = UIImage(named: "Playlist_N")!.withRenderingMode(.alwaysOriginal)
        let playlistHImage = UIImage(named: "Playlist_H")!.withRenderingMode(.alwaysOriginal)
        let favNImage = UIImage(named: "Star_N")!.withRenderingMode(.alwaysOriginal)
        let favHImage = UIImage(named: "Star_H")!.withRenderingMode(.alwaysOriginal)
        let logoutNImage = UIImage(named: "Exit_N")!.withRenderingMode(.alwaysOriginal)
        let logoutHImage = UIImage(named: "Exit_H")!.withRenderingMode(.alwaysOriginal)
        
        playlistVC.tabBarItem = UITabBarItem(title: "Playlist", image: playlistNImage, selectedImage: playlistHImage)
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: favNImage, selectedImage: favHImage)
        logoutVC.tabBarItem = UITabBarItem(title: "Account", image: logoutNImage, selectedImage: logoutHImage)
        
        let playNav = UINavigationController(rootViewController: playlistVC)
        let favorNav = UINavigationController(rootViewController: favoriteVC)
        let logoutNav = UINavigationController(rootViewController: logoutVC)
        
        let tabBarVC = UITabBarController()
        tabBarVC.view.backgroundColor = .white
        tabBarVC.viewControllers = [playNav, favorNav, logoutNav]
        return tabBarVC
    }
    
    private func gotoLoginPage() -> UIViewController {
        return LoginViewController(vm: LoginViewModel())
    }
}
