//
//  TextToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

public class TextToastView : UIStackView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        UILabel()
    }()
    
    public init(
        _ title: NSAttributedString,
        subtitle: NSAttributedString? = nil,
        titleNumberOfLines: Int = 0,
        subtitleNumberOfLines: Int = 0
    ) {
        super.init(frame: CGRect.zero)
        commonInit()
        
        self.titleLabel.attributedText = title
        self.titleLabel.numberOfLines = titleNumberOfLines
        addArrangedSubview(self.titleLabel)
        
        if let subtitle = subtitle {
            self.subtitleLabel.attributedText = subtitle
            self.subtitleLabel.numberOfLines = subtitleNumberOfLines
            addArrangedSubview(subtitleLabel)
        }
    }
    
    public init(
        _ title: String,
        subtitle: String? = nil,
        titleNumberOfLines: Int = 0,
        subtitleNumberOfLines: Int = 0
    ) {
        super.init(frame: CGRect.zero)
        commonInit()
        
        self.titleLabel.text = title
        self.titleLabel.numberOfLines = titleNumberOfLines
        self.titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        addArrangedSubview(self.titleLabel)
        
        if let subtitle = subtitle {
            self.subtitleLabel.textColor = .systemGray
            self.subtitleLabel.text = subtitle
            self.subtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
            self.subtitleLabel.numberOfLines = subtitleNumberOfLines
            addArrangedSubview(self.subtitleLabel)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        axis = .vertical
        alignment = .center
        distribution = .fillEqually
    }
}
