//
//  TabViewController.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 26/08/2018.
//  Copyright © 2018 younari. All rights reserved.
//

import Foundation
import UIKit

public typealias IntegerClosure             = (_ value: Int) -> Void

protocol CommonTabViewDataSource: class {
    func numberOfItems() -> Int
    func tabView(_ tabView: CommonTabView, titleForTabAt index: Int) -> String
    // func tabView(_ tabView: CommonTabView, viewControllerForTabAt index: Int) -> UIViewController
}

protocol CommonTabViewDelegate: class {
    func tabView(_ tabView: CommonTabView, didTab index: Int)
}

class CommonTabView: UIView {
    var tabIndex: Int = 0
    weak var delegate: CommonTabViewDelegate?
    var callBack: IntegerClosure?
    
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.textColor = .lightGray
    }
    
    @IBAction func onSelectTab(_ sender: UIButton) {
        delegate?.tabView(self, didTab: tabIndex)
        self.selectTab()
        callBack?(self.tabIndex)
    }
    
    func deSelectTab() {
        self.tabButton.isSelected = false
        self.titleLabel.textColor = .lightGray
    }
    
    func selectTab() {
        self.titleLabel.textColor = .darkGray
        self.tabButton.isSelected = true
    }
    
}

class TabViewController: UIViewController, RouterProtocol, CommonTabViewDelegate {
    
    static var storyboardName: String = "Main"
    weak var delegate: CommonTabViewDelegate?
    weak var dataSource: CommonTabViewDataSource?
    
    @IBOutlet weak var stackView: UIStackView!
    var subTabViews = [CommonTabView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.distribution = .fillEqually
    }
    
    var selectedIndex: Int = 0
    var selectedTab: CommonTabView?
    
    func tabView(_ tabView: CommonTabView, didTab index: Int) {
        self.selectedTab?.deSelectTab()
        self.selectedIndex = index
        self.selectedTab = self.subTabViews[index]
        self.delegate?.tabView(tabView, didTab: index)
    }
    
    func moveTabPage(_ index: Int) {
        self.selectedTab?.deSelectTab()
        self.selectedIndex = index
        self.selectedTab = self.subTabViews[index]
        self.subTabViews[index].selectTab()
    }
    
    func configure(_ selectedIndex: Int, delegate: CommonTabViewDelegate, dataSource: CommonTabViewDataSource, callBack: IntegerClosure? = nil) {
        self.delegate = delegate
        self.dataSource = dataSource
        var array = [CommonTabView]()
        for i in 0...dataSource.numberOfItems() - 1 {
            let tabView: CommonTabView = CommonTabView.fromNib()
            tabView.titleLabel?.text = dataSource.tabView(tabView, titleForTabAt: i)
            tabView.tabIndex = i
            tabView.delegate = self
            if i == selectedIndex {
                tabView.selectTab()
            }
            tabView.callBack = callBack
            array.append(tabView)
        }
        self.subTabViews = array
        self.stackView.removeSubviews()
        for v in self.subTabViews {
            self.stackView.addArrangedSubview(v)
        }
        self.selectedIndex = selectedIndex
        self.selectedTab = self.subTabViews[selectedIndex]
    }
    
}

