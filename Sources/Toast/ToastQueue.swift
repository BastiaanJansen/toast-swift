//
//  File.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import Foundation

public class ToastQueue {
    
    private var queue: [Toast]
    
    public init(toasts: [Toast] = []) {
        self.queue = toasts
    }
    
    public func enqueue(toast: Toast) -> Void {
        queue.append(toast)
    }
    
    public func enqueue(toasts: [Toast]) -> Void {
        toasts.forEach({ queue.append($0) })
    }
    
    public func show() -> Void {
        if (queue.isEmpty) {
            return
        }
        
        show(index: 0)
    }
    
    private func show(index: Int) -> Void {
        let toast: Toast = queue.remove(at: index)
        let delegate = ToastQueueDelegate(queue: self)
        
        toast.addDelegate(delegate: delegate)
        toast.show()
    }
    
    
    private class ToastQueueDelegate: ToastDelegate {
        
        private var queue: ToastQueue
        
        public init(queue: ToastQueue) {
            self.queue = queue
        }
        
        public func didCloseToast(_ toast: Toast) {
            queue.show()
        }
        
    }
    
}
