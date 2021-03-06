//
//  ChoosePokemonViewControllerTransitionDelegate.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 23/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation
import UIKit

extension ChoosePokemonViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let originFrame = transitionSourceView.superview?.convert(transitionSourceView.frame, to: nil) else {
            return transition
        }
        transition.originFrame = originFrame
        transition.presenting = true
        transitionSourceView.isHidden = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
