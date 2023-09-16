//
//  File.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import Foundation

public protocol ToastQueueDelegate: AnyObject {
    
    func willShowAnyToast(_ toast: Toast) -> Void
    
    func didShowAnyToast(_ toast: Toast) -> Void
    
}

extension ToastQueueDelegate {
    
    public func willShowAnyToast(toast: Toast) {}
    
    public func didShowAnyToast(toast: Toast) {}
    
}
