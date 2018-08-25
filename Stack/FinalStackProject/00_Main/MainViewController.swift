//
//  MainTabBarController.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 21/10/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit
import PageController

enum MainType: String {
    case explore = "Explore"
    case list = "List"
    case calendar = "Calendar"
    case setting = "Setting"
    
    var controller: UIViewController {
        get {
            switch self {
            case .explore:
                let vc = Router.getViewController(ExploreController.self)
                vc.title = self.rawValue
                return vc
            case .list:
                let vc = Router.getViewController(ListMainController.self)
                vc.title = self.rawValue
                return vc
            case .calendar:
                let vc = Router.getViewController(CalendarListController.self)
                vc.title = self.rawValue
                return vc
            case .setting:
                let vc = Router.getViewController(SettingController.self)
                vc.title = self.rawValue
                return vc
            }
        }
    }
}

class MainViewController: PageController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.shared.mainNavigation = self.navigationController
        viewControllers = createViewControllers()
        menuBar.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        menuBar.register(UINib(nibName: "MenuBarCell", bundle: nil))
        menuBar.isAutoSelectDidEndUserInteractionEnabled = false
        delegate = self
    }
    
    override var frameForMenuBar: CGRect {
        let frame = super.frameForMenuBar
        return CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 200)
    }
    
    func createViewControllers() -> [UIViewController] {
        return [MainType.explore.controller, MainType.calendar.controller, MainType.list.controller, MainType.setting.controller]
    }
    
}

extension MainViewController: PageControllerDelegate {
    func pageController(_ pageController: PageController, didChangeVisibleController visibleViewController: UIViewController, fromViewController: UIViewController?) {
        
    }
    
    
}
