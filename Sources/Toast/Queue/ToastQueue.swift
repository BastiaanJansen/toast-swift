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
    private var isShowing = false
    
    public init(toasts: [Toast] = [], delegates: [ToastQueueDelegate] = []) {
        self.queue = toasts
        delegates.forEach(multicast.add)
    }
    
    public func enqueue(_ toast: Toast) -> Void {
        queue.append(toast)
    }
    
    public func enqueue(_ toasts: [Toast]) -> Void {
        let size = queue.count
        toasts.forEach({ queue.append($0) })
        
        if size == 0 && isShowing {
            show()
        }
    }
    
    public func dequeue(_ toastToDequeue: Toast) -> Void {
        let index: Int? = queue.firstIndex { $0 === toastToDequeue }
        
        if let index {
            queue.remove(at: index)
        }
    }
    
    public func size() -> Int {
        return queue.count
    }
    
    public func show() -> Void {
        show(index: 0)
    }
    
    private func show(index: Int, after: Double = 0.0) -> Void {
        isShowing = true
        if queue.isEmpty {
            return
        }
        
        let toast: Toast = queue.remove(at: index)
        let delegate = QueuedToastDelegate(queue: self)
        
        multicast.invoke { $0.willShowAnyToast(toast, queuedToasts: queue) }
        
        toast.addDelegate(delegate: delegate)
        toast.show(after: after)
    }
    
    
    private class QueuedToastDelegate: ToastDelegate {
        
        private var queue: ToastQueue
        
        public init(queue: ToastQueue) {
            self.queue = queue
        }
        
        public func didCloseToast(_ toast: Toast) {
            queue.multicast.invoke { $0.didShowAnyToast(toast, queuedToasts: queue.queue) }
            queue.show(index: 0, after: 0.5)
        }
        
    }
    
}
