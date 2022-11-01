//
//  ToastDelegate.swift
//  Toast
//
//  Created by Zandor Smith on 01/11/2022.
//

import Foundation

public protocol ToastDelegate: AnyObject {

    func didShowToast(_ toast: Toast)
    func didCloseToast(_ toast: Toast)

}

extension ToastDelegate {

    func didShowToast(_ toast: Toast) {}
    func didCloseToast(_ toast: Toast) {}

}
