//
//  MainTabBarController.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 21/10/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit
import PageController

let UISCREEN_WIDTH = UIScreen.main.bounds.width
let UISCREEN_HEIGHT = UIScreen.main.bounds.height

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

class MainViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var menuTabView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    var tabViewController: TabViewController?
    
    var controllers = [UIViewController]()
    var currentPage: Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TabViewController {
            self.tabViewController = viewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.shared.mainNavigation = self.navigationController
        if #available(iOS 11.0, *) {
            self.contentScrollView.contentInsetAdjustmentBehavior = .never
        }
        self.contentScrollView.delegate = self
        
        self.createViewControllers()
        self.tabViewController?.configure(self.currentPage, delegate: self, dataSource: self)
        self.contentScrollView.isPagingEnabled = true
        self.contentScrollView.showsHorizontalScrollIndicator = false
    }
    
    @discardableResult
    func createViewControllers() -> [UIViewController] {
        self.controllers = [MainType.explore.controller, MainType.calendar.controller, MainType.list.controller, MainType.setting.controller]
        self.controllers.forEach { self.addChildViewController($0) }
        
        let views: [UIView] = self.controllers.map { $0.view }
        self.containerView.addSubViewAutoLayout(subviews: views, addType: VIEW_ADD_TYPE.horizontal, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return self.controllers
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let targetPage = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.tabViewController?.moveTabPage(Int(targetPage))
        self.currentPage = Int(targetPage)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let targetPage = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.tabViewController?.moveTabPage(Int(targetPage))
        self.currentPage = Int(targetPage)
    }
    
}

extension MainViewController: CommonTabViewDelegate, CommonTabViewDataSource {
    func numberOfItems() -> Int {
        return self.controllers.count
    }
    
    func tabView(_ tabView: CommonTabView, titleForTabAt index: Int) -> String {
        let titles = self.controllers.map { $0.title }
        return titles[index] ?? ""
    }
    
    func tabView(_ tabView: CommonTabView, didTab index: Int) {
        self.contentScrollView.setContentOffset(CGPoint(x: UISCREEN_WIDTH * CGFloat(index), y: 0), animated: true)
        self.currentPage = index
    }
}
