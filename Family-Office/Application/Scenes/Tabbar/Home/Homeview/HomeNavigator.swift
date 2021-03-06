//
//  HomeNavigator.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 07/02/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

protocol HomeNavigatorPr {
    func toMain()
    func toModule(homeBtn: HomeBtn)
}
class HomeNavigator: HomeNavigatorPr {
    private let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func toMain() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewmodel(navigator: self)
        vc.title = "Menu"
        navigationController.pushViewController(vc, animated: true)
    }
    
    /// Crea y te redirige al modulo de Asistentes
    ///
    /// - Parameters:
    ///   - mainNavigationController: navigation principal que se manejará en este modulo.
    ///   - tabBarController: tabbar principal que se manejará en este modulo.
    ///   - homeBtn: contenedor que traé las propiedades que se establecerán para el modulo. Ej: color.
    fileprivate func toAssistant(_ mainNavigationController: UINavigationController, _ tabBarController: UITabBarController, _ homeBtn: HomeBtn) {
        mainNavigationController.tabBarItem = UITabBarItem(title: "Tareas", image: #imageLiteral(resourceName: "task_completed"), selectedImage: nil)
        let mainNavigator = AssistantMainNavigator(service: SuperProvider(), nc: mainNavigationController)
        
        let profileAssistant = UINavigationController( )
        profileAssistant.tabBarItem = UITabBarItem(title: "Asistente", image: #imageLiteral(resourceName: "clipboard"), selectedImage: nil)
        let profileAssitantNavigator = ProfileAssistantNavigator(service: RMUseCaseProvider(), nc: profileAssistant)
        let addeditPendingNavigationController = UINavigationController()
        
        let adPendingNavigator = AddeditPendingNavigator(service: SuperProvider(), nc: addeditPendingNavigationController)
        addeditPendingNavigationController.tabBarItem = UITabBarItem(title: "Agregar", image: #imageLiteral(resourceName: "icons8-plus_2_math"), selectedImage: nil)
        
        tabBarController.viewControllers = [
            mainNavigationController,
            profileAssistant,
            addeditPendingNavigationController]
        setMenu()
        tabBarController.setStyle(homeBtn)
        mainNavigator.toMain()
        adPendingNavigator.toMain(pending: Pending())
        profileAssitantNavigator.toMain()
        navigationController.present(tabBarController, animated: true, completion: nil)
    }
    
    fileprivate func setMenu() {
        let menu = MenuAssistantsViewController()
        menu.viewModel = MenuAssistantViewModel(userUseCase: RMUseCaseProvider().makeUseCase())
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menu)
        menuLeftNavigationController.view.backgroundColor = #colorLiteral(red: 0.9792956669, green: 0.9908331388, blue: 1, alpha: 1)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    }
    
    func toModule(homeBtn: HomeBtn) {
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = #colorLiteral(red: 0.9792956669, green: 0.9908331388, blue: 1, alpha: 1)

        let mainNavigationController = UINavigationController()
        mainNavigationController.navigationBar.barTintColor = homeBtn.color
        mainNavigationController.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tabBarController.tabBar.tintColor = homeBtn.color
        
        switch homeBtn.module {
            case .ASSISTANT:
                toAssistant(mainNavigationController, tabBarController, homeBtn)
            break
            case .FIRSTKIT:
                let navigator = MainIllnessNavigator(navigationController: mainNavigationController)
                navigator.toMain()
                navigationController.present(mainNavigationController, animated: true, completion: nil)
                break
            case .INSURANCE:
                let navigator = InsuranceNavigator(navigationController: mainNavigationController)
                navigator.toMain()
                navigationController.present(mainNavigationController, animated: true, completion: nil)
            break
            case .CHAT:
                let membersnc = UINavigationController()
                let service = SuperProvider().rmusecaseprovider
                let membersnavigator = MembersChatNavigator(nc: membersnc, service: service)
                membersnc.tabBarItem = UITabBarItem(title: "Miembros", image: #imageLiteral(resourceName: "icons8-conference_call"), selectedImage: nil)
                membersnavigator.toMain(sender: nil)
                
                let mychatsnc = UINavigationController()
                let mychatsNavigator = ChatsNavigator(nc: mychatsnc, service: service)
                mychatsnc.tabBarItem =  UITabBarItem(title: "Chats", image: #imageLiteral(resourceName: "icons8-filled_chat"), selectedImage: nil)
                mychatsNavigator.toMain(sender: 0)
                let mygroupsnc = UINavigationController()
                let mygroupsNavigator = ChatsNavigator(nc: mygroupsnc, service: service)
                mygroupsnc.tabBarItem =  UITabBarItem(title: "Chats", image: #imageLiteral(resourceName: "groups-conference"), selectedImage: nil)
                mygroupsNavigator.toMain(sender: 1)
                
                tabBarController.viewControllers = [mychatsnc, mygroupsnc ,membersnc]
                tabBarController.setStyle(homeBtn)
                navigationController.present(tabBarController, animated: true, completion: nil)
                break
            
        default:
            break
        }
    }
}
