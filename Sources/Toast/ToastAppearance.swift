//
//  ToastAppearance.swift
//  ToastTest
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

protocol ToastAppearance {
    func addConstraints(to view: UIView)
    func style(view: UIView)
}
