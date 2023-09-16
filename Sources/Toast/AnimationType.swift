//
//  File.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import Foundation
import UIKit

extension Toast {
    /// Built-in animations for your toast
    public enum AnimationType {
        /// Use this type for fading in/out animations.
        case slide(x: CGFloat, y: CGFloat)

        /// Use this type for fading in/out animations.
        ///
        /// alphaValue must be greater or equal to 0 and less or equal to 1.
        case fade(alphaValue: CGFloat)
        
        /// Use this type for scaling and slide in/out animations.
        case scaleAndSlide(scaleX: CGFloat, scaleY: CGFloat, x: CGFloat, y: CGFloat)
        
        /// Use this type for scaling in/out animations.
        case scale(scaleX: CGFloat, scaleY: CGFloat)
        
        /// Use this type for giving your own affine transformation
        case custom(transformation: CGAffineTransform)
        
        /// Currently the default animation if no explicit one specified.
        case `default`
        
        func apply(to view: UIView) {
            switch self {
            case .slide(x: let x, y: let y):
                view.transform = CGAffineTransform(translationX: x, y: y)
                
            case .fade(let value):
                view.alpha = value
                
            case .scaleAndSlide(let scaleX, let scaleY, let x, let y):
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY).translatedBy(x: x, y: y)
                
            case .scale(let scaleX, let scaleY):
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                
            case .custom(let transformation):
                view.transform = transformation
                
            case .`default`:
                break
            }
        }
        
        /// Undo the effects from the ToastView so that it never happened.
        func undo(from view: UIView) {
            switch self {
            case .slide, .scaleAndSlide, .scale, .custom:
                view.transform = .identity
                
            case .fade:
                view.alpha = 1.0
                
            case .`default`:
                break
            }
        }
    }

}
