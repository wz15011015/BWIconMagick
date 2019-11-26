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

            addIconImageViews(icons: icons)
        }
    }
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        adaptationDarkModeFor(icons: icons)
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
        
    }
    
    /// 添加图标视图
    /// - Parameter icons: 图标数组
    private func addIconImageViews(icons: [BWIcon]) {
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
        let space_horizontal: CGFloat = 8 // 水平间距
        for (i, icon) in icons.enumerated() {
            let x = CGFloat(i % column) * (IconImageViewW + space_horizontal)
            let y = CGFloat(i / column) * (IconImageViewW + space_vertical) + space_vertical
            
            let iconImageView = NSImageView(frame: NSRect(x: x, y: y, width: IconImageViewW, height: IconImageViewW))
            iconImageView.wantsLayer = true
            iconImageView.layer?.backgroundColor = RGBColor(52, 53, 53).cgColor
            iconImageView.tag = IconImageViewTag + i
            addSubview(iconImageView)
            
            let sizeLabelX: CGFloat = x - 2
            let sizeLabelW: CGFloat = IconImageViewW + 4
            let sizeLabelH: CGFloat = 14
            let sizeLabelY: CGFloat = iconImageView.frame.minY - sizeLabelH - 2
            let sizeLabel = NSText(frame: NSRect(x: sizeLabelX, y: sizeLabelY, width: sizeLabelW, height: sizeLabelH))
            sizeLabel.isEditable = false
            sizeLabel.textColor = NSColor(named: "IconImageViewSizeLabelColor")
            sizeLabel.alignment = .center
            sizeLabel.backgroundColor = NSColor.clear
            addSubview(sizeLabel)

            let size = icon.sizeString
            let scale = icon.scaleString
            sizeLabel.string = "\(size)x\(size)\(scale)"
        }
    }
    
    /// 显示图标
    /// - Parameter icons: 图标数组
    func show(icons: [BWIcon]?) {
        guard let icons = icons else { return }
        
        for (i, icon) in icons.enumerated() {
            guard let iconImageView = viewWithTag(IconImageViewTag + i) as? NSImageView else {
                return
            }
            iconImageView.image = icon.image
        }
    }
    
    /// 图标图片背景色适配黑暗模式
    func adaptationDarkModeFor(icons: [BWIcon]?) {
        guard let icons = icons else { return }
        
        for (i, _) in icons.enumerated() {
            guard let iconImageView = viewWithTag(IconImageViewTag + i) as? NSImageView else {
                return
            }
            // 设置图片背景颜色
            iconImageView.wantsLayer = true
            if isDarkMode() {
                iconImageView.layer?.backgroundColor = RGBColor(52, 53, 53).cgColor
            } else {
                iconImageView.layer?.backgroundColor = RGBColor(252, 253, 253).cgColor
            }
        }
    }
}
