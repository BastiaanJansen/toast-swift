//
//  File.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import Foundation

public class ToastQueue {
    
    private var queue: [Toast]
    private var multicast = MulticastDelegate<ToastQueueDelegate>()
    
    public init(toasts: [Toast] = [], delegates: [ToastQueueDelegate] = []) {
        self.queue = toasts
        delegates.forEach(multicast.add)
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
        let delegate = QueuedToastDelegate(queue: self)
        
        multicast.invoke { $0.willShowAnyToast(toast) }
        
        toast.addDelegate(delegate: delegate)
        toast.show()
    }
    
    
    private class QueuedToastDelegate: ToastDelegate {
        
        private var queue: ToastQueue
        
        public init(queue: ToastQueue) {
            self.queue = queue
        }
        
        public func didCloseToast(_ toast: Toast) {
            queue.multicast.invoke { $0.didShowAnyToast(toast) }
            queue.show()
        }
        
    }
    
}
