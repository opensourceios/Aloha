//
//  customOverlayView.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/26/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

open class SwiftyOnboardOverlay: UIView {
    
    open var pageControl: CHIPageControlChimayo = {
        let pageControl = CHIPageControlChimayo()
        pageControl.tintColor = .themeColor
        pageControl.padding = 6
        pageControl.radius = 4
        
        return pageControl
    }()
    
    open var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    open var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    open func set(style: SwiftyOnboardStyle) {
        switch style {
        case .light:
            continueButton.setTitleColor(.white, for: .normal)
            skipButton.setTitleColor(.white, for: .normal)
        case .dark:
            continueButton.setTitleColor(.black, for: .normal)
            skipButton.setTitleColor(.black, for: .normal)
        }
    }
    
    open func page(count: Int) {
        pageControl.numberOfPages = count
    }
    
    open func currentPage(index: Int) {
        pageControl.set(progress: index, animated: true)
    }
    
    func setUp() {
        self.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -170).isActive = true
        pageControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        pageControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
}
