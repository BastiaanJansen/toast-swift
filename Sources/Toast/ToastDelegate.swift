//
//  ToastDelegate.swift
//  Toast
//
//  Created by Zandor Smith on 01/11/2022.
//

import Foundation

public protocol ToastDelegate: AnyObject {

    /// Delegate function that will be called before the Toast is shown.
    /// - Parameters:
    ///   - toast: The toast that will be shown.
    func willShowToast(_ toast: Toast)

    /// Delegate function that will be called after the Toast is shown.
    /// - Parameters:
    ///   - toast: The toast that was just shown.
    func didShowToast(_ toast: Toast)

    /// Delegate function that will be called before the Toast is closed.
    /// - Parameters:
    ///   - toast: The toast that will be closed.
    func willCloseToast(_ toast: Toast)

    /// Delegate function that will be called after the Toast is closed.
    /// - Parameters:
    ///   - toast: The toast that was just closed.
    func didCloseToast(_ toast: Toast)

}

extension ToastDelegate {

    func willShowToast(_ toast: Toast) {}

    func didShowToast(_ toast: Toast) {}

    func willCloseToast(_ toast: Toast) {}

    func didCloseToast(_ toast: Toast) {}

}
