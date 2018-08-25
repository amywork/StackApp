//
//  NavigationManager.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 25/08/2018.
//  Copyright © 2018 younari. All rights reserved.
//

import UIKit

public typealias VoidClosure = () -> Void
public typealias NavigationAnimationClosure = (_ fromViewController: UIViewController, _ toViewController: UIViewController, _ completion:@escaping VoidClosure) -> Void


public enum NavigationAnimationType: Int {
    case none = 0
    case left
    case right
    case up
    case down
    case snapShot
}

protocol NavigationAnimatorAble {
    var pushAnimation: PushAnimator? { get }
    var popAnimation: PopAnimator? { get }
}


class NavigationManager: NSObject {
    
    static let shared = NavigationManager()
    
    weak var mainNavigation: UINavigationController? {
        didSet {
            mainNavigation?.delegate = self
            mainNavigation?.interactivePopGestureRecognizer?.delegate = self
        }
    }
}

//MARK: - UINavigationControllerDelegate
extension NavigationManager: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        
        if operation == .push {
            if let vc = toVC as? NavigationAnimatorAble {
                return vc.pushAnimation
            }
        }
        else if operation == .pop {
            if let vc = fromVC as? NavigationAnimatorAble, let popAnimation = vc.popAnimation {
                if (popAnimation.isAnimation) {
                    return vc.popAnimation
                }
            }
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if let animator = animationController as? PopAnimator {
            return animator.interactionController
        }
        return nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if navigationController.viewControllers.count < 2 {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
