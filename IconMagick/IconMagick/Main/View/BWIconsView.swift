//
//  BWIconsView.swift
//  IconMagick
//
//  Created by hadlinks on 2019/11/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

class BWIconsView: NSView {
    
//    var icons: [BWIcon]? {
//        didSet {
//            guard let icons = icons else { return }
//
//            setupUI(with: icons)
//        }
//    }
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}


// MARK: - UI

extension BWIconsView {
    
    func setupUI(with icons: [BWIcon]) {
//        for (index, icon) in icons.reversed().enumerated() {
//            print("icon info: \(index) - \(icon.size) \(icon.scale)")
//
//            let iconImageView = NSImageView(frame: NSRect(x: 0, y: (index * 3) + (80 * index), width: 80, height: 80))
//            iconImageView.wantsLayer = true
//            iconImageView.layer?.backgroundColor = NSColor.green.cgColor
//            addSubview(iconImageView)
//        }
    }
    
    func showIcons(with icons: [BWIcon]) {
        for (index, icon) in icons.reversed().enumerated() {
            print("icon info: \(index) - \(icon.size) \(icon.scale)")
            
            let iconImageView = NSImageView(frame: NSRect(x: 0, y: (index * 3) + (80 * index), width: 80, height: 80))
            iconImageView.wantsLayer = true
            iconImageView.layer?.backgroundColor = NSColor.green.cgColor
            iconImageView.image = icon.image
            addSubview(iconImageView)
        }
    }
}
