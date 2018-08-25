//
//  PopAnimator.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 25/08/2018.
//  Copyright © 2018 younari. All rights reserved.
//

import UIKit

public typealias BoolReturnClosure = () -> Bool

class PopAnimator: NSObject   {
    
    var touchViews = [UIView]()
    var scrollViews = [UIView]()
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    var duration: TimeInterval = 0.2
    var animation: NavigationAnimationClosure?
    var type: NavigationAnimationType = .none
    
    weak var tagetViewController: UIViewController?
    var checkStart: BoolReturnClosure?
    var isOnlyGesture: Bool = false {
        willSet {
            self.isAnimation = !newValue
        }
    }
    var isAnimation: Bool = true
    
    public init(animationType: NavigationAnimationType, duration: TimeInterval = 0.2, animation: NavigationAnimationClosure? = nil){
        
        self.animation = animation
        self.duration = duration
        self.type = animationType
    }
    
    public convenience init(animationType: NavigationAnimationType, tagetViewController: UIViewController, tagetView: UIView) {
        self.init(animationType: animationType, duration: 0.3, animation: nil)
        self.tagetViewController = tagetViewController
        self.addTagetView(tagetView)
    }
    
    public init(animation: @escaping NavigationAnimationClosure){
        super.init()
        self.animation = animation
    }
    
    func setAnimation(_ closure: @escaping NavigationAnimationClosure) -> Void {
        self.animation = closure
    }
    
    func addTagetView(_ tagetView: UIView) {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizer))
        panRecognizer.delegate = self
        tagetView.addGestureRecognizer(panRecognizer)
        if let tagetView = tagetView as? UIScrollView {
            tagetView.bounces = false
            scrollViews.append(tagetView)
        }
        else {
            touchViews.append(tagetView)
        }
        
        
    }
    
    @objc func panGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        guard let tagetViewController = self.tagetViewController, let view = tagetViewController.view else {
            return
        }
        
        let velocity: CGPoint = recognizer.velocity(in: recognizer.view)
        let isVelocity: Bool
        let isCheckGesture: Bool
        switch self.type {
        case .none, .snapShot:
            isVelocity = false
            isCheckGesture = false
            
        case .left:
            isVelocity = velocity.x > 0
            isCheckGesture = fabs(velocity.y) > fabs(velocity.x)
            
        case .right:
            isVelocity = velocity.x < 0
            isCheckGesture = fabs(velocity.y) > fabs(velocity.x)
            
        case .up:
            isVelocity = velocity.y < 0
            isCheckGesture = fabs(velocity.y) < fabs(velocity.x)
            
        case .down:
            isVelocity = velocity.y > 0
            isCheckGesture = fabs(velocity.y) < fabs(velocity.x)
            
        }
        if recognizer.state == .began {
            
            if isCheckGesture {
                return
            }
            
            if (isVelocity) {
                return;
            }
            
            if let callback = self.checkStart {
                if callback() == false {
                    return
                }
            }
            else if let scrollView =  recognizer.view as? UIScrollView {
                if scrollView.contentOffset.y + scrollView.contentInset.top != 0 {
                    return
                }
            }
            
            
            
            if let nv = tagetViewController.navigationController {
                if nv.viewControllers.count > 1 && self.interactionController == nil {
                    if isOnlyGesture {
                        isAnimation = true
                    }
                    self.interactionController = UIPercentDrivenInteractiveTransition()
                    nv.popViewController(animated: true)
                }
                
            }
            
            
        }
        else if recognizer.state == .changed {
            
            if let interactionController = self.interactionController {
                let translation: CGPoint = recognizer.translation(in: view)
                let d: CGFloat
                switch self.type {
                case .none, .snapShot:
                    d = 0
                    
                case .left, .right:
                    d = fabs(translation.x) / view.bounds.width
                    
                case .up, .down:
                    d = fabs(translation.y) / view.bounds.height
                    
                }
                //                print(translation.y)
                if self.type == .up && translation.y < 0 { return }
                interactionController.update(d)
            }
            
            
        }
        else if recognizer.state == .ended {
            if let interactionController = self.interactionController {
                let endCheck: Bool
                switch self.type {
                case .none, .snapShot:
                    endCheck = false
                    
                case .left:
                    endCheck = recognizer.velocity(in: view).x < -50
                    
                case .right:
                    endCheck = recognizer.velocity(in: view).x > 50
                    
                case.up:
                    endCheck = recognizer.velocity(in: view).y > 50
                    
                case .down:
                    endCheck = recognizer.velocity(in: view).y < -50
                    
                }
                
                if endCheck {
                    interactionController.finish()
                }
                else {
                    interactionController.cancel()
                }
                
                if isOnlyGesture {
                    isAnimation = false
                }
                self.interactionController = nil
            }
            
        }
        else {
            
            if let interactionController = self.interactionController {
                interactionController.cancel()
                self.interactionController = nil
                
                if self.isOnlyGesture {
                    self.isAnimation = false;
                }
            }
            
            
        }
    }
}

extension PopAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController: UIViewController = transitionContext.viewController(forKey: .to),
            let fromViewController: UIViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }
        
        func complete() {
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        if let callback = self.animation {
            toViewController.view.frame = transitionContext.containerView.bounds
            transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            callback(fromViewController, toViewController, {
                complete()
            })
        }
        else {
            switch self.type {
            case .none, .snapShot:
                transitionContext.containerView.addSubview(toViewController.view)
                if let snapShotView = fromViewController.view.viewWithTag(SnapShotView.TAG) as? SnapShotView {
                    snapShotView.removeFromSuperview()
                }
                
                complete()
                
                
            case .left, .right:
                
                transitionContext.containerView.addSubview(toViewController.view)
                
                guard let snapShotView = fromViewController.view.viewWithTag(SnapShotView.TAG) as? SnapShotView else {
                    complete()
                    return
                }
                snapShotView.isHidden = true
                toViewController.view.frame = snapShotView.frame
                
                let layerView = UIView(frame: toViewController.view.bounds)
                layerView.backgroundColor = UIColor.black
                layerView.alpha = LeftRigthLayerAlpha
                toViewController.view.addSubview(layerView)
                
                UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                    toViewController.view.frame.origin.x  = 0;
                    layerView.alpha = 0.0
                    
                }, completion: {(_ finished: Bool) -> Void in
                    layerView.removeFromSuperview()
                    if transitionContext.transitionWasCancelled {
                        snapShotView.isHidden = false
                    }
                    else {
                        snapShotView.removeFromSuperview()
                    }
                    complete()
                })
                
                
            case .up:
                toViewController.view.frame = transitionContext.containerView.bounds
                transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
                let snapShotView = fromViewController.view.viewWithTag(SnapShotView.TAG) as? SnapShotView
                snapShotView?.isHidden = true
                
                let layerView = UIView(frame: toViewController.view.frame)
                layerView.backgroundColor = UIColor.black
                layerView.alpha = SnapShotView.DimLayerAlpha
                toViewController.view.addSubview(layerView)
                
                let backgroundColor: UIColor? = fromViewController.view.backgroundColor
                fromViewController.view.backgroundColor = UIColor.clear
                
                UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                    fromViewController.view.frame.origin.y = fromViewController.view.frame.size.height
                    layerView.alpha = 0
                }, completion: {(_ finished: Bool) -> Void in
                    layerView.removeFromSuperview()
                    if transitionContext.transitionWasCancelled {
                        snapShotView?.isHidden = false
                        fromViewController.view.backgroundColor = backgroundColor
                    }
                    else {
                        snapShotView?.removeFromSuperview()
                    }
                    
                    complete()
                })
                
                
            case .down:
                transitionContext.containerView.addSubview(toViewController.view)
                if let snapShotView = fromViewController.view.viewWithTag(SnapShotView.TAG) as? SnapShotView {
                    snapShotView.removeFromSuperview()
                }
                
                complete()
                
            }
        }
        
    }
}


extension PopAnimator: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if touchViews.contains( gestureRecognizer.view! ) {
            if otherGestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UILongPressGestureRecognizer {
                return false
            }
        }
        else if scrollViews.contains( gestureRecognizer.view! ) {
            if otherGestureRecognizer is UILongPressGestureRecognizer {
                return false
            }
        }
        
        return true
    }
}
