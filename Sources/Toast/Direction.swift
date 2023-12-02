//
//  File.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import Foundation

extension Toast {
 
    /// The direction where the toast will be displayed
    public enum Direction {
        case top, bottom, center
    }
    
    public enum DismissSwipeDirection: Equatable {
        case toTop,
             toBottom,
             natural
        
        func shouldApply(_ delta: CGFloat, direction: Direction) -> Bool {
            switch self {
            case .toTop:
                return delta <= 0
            case .toBottom:
                return delta >= 0
            case .natural:
                switch direction {
                case .top:
                    return delta <= 0
                case .bottom:
                    return delta >= 0
                case .center:
                    return delta <= 0
                }
            }
        }
    }
    
}
