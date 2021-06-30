//
//  ToastAppearance.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

protocol ToastAppearance {
    func addConstraints(to view: Toast)
    func style(view: Toast)
}
