//
//  BWIconsView.swift
//  IconMagick
//
//  Created by hadlinks on 2019/11/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

// 图标视图Tag值
let IconImageViewTag = 100

/// 图标视图的宽高
let IconImageViewW: CGFloat = 84.0


class BWIconsView: NSView {
    
    var icons: [BWIcon]? {
        didSet {
            guard let icons = icons else { return }

            addIconImageViews(with: icons)
        }
    }
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
}


// MARK: - UI

extension BWIconsView {
    
    private func setupUI() {
//        wantsLayer = true
//        layer?.backgroundColor = NSColor.orange.cgColor
    }
    
    /// 添加图标视图
    /// - Parameter icons: 图标数组
    private func addIconImageViews(with icons: [BWIcon]) {
        // 计算行数,列数
//        let count = icons.count
        let column = 5 // 列数
//        var row = 0 // 行数
//        if count % column == 0 {
//            row = count / column
//        } else {
//            row = count / column + 1
//        }
        
        let space_vertical: CGFloat = 18 // 竖直间距
        let space_horizontal: CGFloat = 5 // 水平间距
        for (i, icon) in icons.enumerated() {
            let x = CGFloat(i % column) * (IconImageViewW + space_horizontal)
            let y = CGFloat(i / column) * (IconImageViewW + space_vertical) + space_vertical
            
            let iconImageView = NSImageView(frame: NSRect(x: x, y: y, width: IconImageViewW, height: IconImageViewW))
            iconImageView.wantsLayer = true
            iconImageView.layer?.backgroundColor = RGBColor(52, 53, 53).cgColor
            iconImageView.tag = IconImageViewTag + i
            addSubview(iconImageView)
            
            let sizeLabelH: CGFloat = 14
            let sizeLabel = NSText(frame: NSRect(x: x, y: iconImageView.frame.minY - sizeLabelH - 2, width: IconImageViewW, height: sizeLabelH))
            sizeLabel.isEditable = false
            sizeLabel.textColor = NSColor.white
            sizeLabel.alignment = .center
            sizeLabel.backgroundColor = NSColor.clear
            addSubview(sizeLabel)

            var size = String(format: "%.f", icon.size)
            // 针对83.5的显示处理
            if icon.size == 83.5 {
                size = "83.5"
            }
            let scale = Int(icon.scale)
            if scale == 1 {
                sizeLabel.string = "\(size)x\(size)"
            } else {
                sizeLabel.string = "\(size)x\(size)@\(scale)x"
            }
        }
    }
    
    /// 显示图标
    /// - Parameter icons: 图标数组
    func showIcons(with icons: [BWIcon]?) {
        guard let icons = icons else { return }
        
        for (i, icon) in icons.enumerated() {
            guard let iconImageView = viewWithTag(IconImageViewTag + i) as? NSImageView else {
                return
            }
            iconImageView.image = icon.image
        }
    }
}
