//
//  BWIconsView.swift
//  IconMagick
//
//  Created by wangzhi on 2019/11/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

/// 图标类型
enum BWIconType {
    case iPhone
    case iPad
    case Mac
}


// 图标视图的初始Tag值
private let IconButtonTag = 100

/// 图标的宽高
private let IconImageViewW: CGFloat = 84.0
/// 图标的水平间距
private let IconImageViewSpaceHorizontal: CGFloat = 8.0
/// 图标的竖直间距
private let IconImageViewSpaceVertical: CGFloat = 18.0

/// 视图的高度
let BWIconsViewH: CGFloat = 206


class BWIconsView: NSView {
    
    /// 放置多个图标的View
    private var iconView: NSView = {
        let view = NSView()
        return view
    }()
    
    /// 保存按钮
    private var saveButton: NSButton = {
        let button = NSButton(title: NSLocalizedString("Save", comment: ""), target: nil, action: #selector(saveEvent))
        button.isEnabled = false
        return button
    }()
    
    var icons: [BWIcon]? {
        didSet {
            guard let icons = icons else { return }

            addIconImageViews(icons: icons)
        }
    }
    
    /// 图标类型
    var iconType: BWIconType = .iPhone
    
    /// 图标点击事件
    var iconTapHandler: ((_ icon: BWIcon) -> ())?
    
    /// 图标保存事件
    var iconSaveHandler: ((_ iconType: BWIconType) -> ())?
    

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
    
    
    // MARK: Events
    
    /// 点击了保存按钮
    @objc func saveEvent() {
        iconSaveHandler?(iconType)
    }
}


// MARK: - UI

extension BWIconsView {
    
    private func setupUI() {
        saveButton.target = self
        
        addSubview(iconView)
        addSubview(saveButton)
        
        // 2行 5列
        let iconViewW = (IconImageViewW * 5) + (IconImageViewSpaceHorizontal * 4)
        let iconViewH = (IconImageViewW * 2) + (IconImageViewSpaceVertical * 2)
        iconView.frame = CGRect(x: 0, y: 0, width: iconViewW, height: iconViewH)
        saveButton.frame = CGRect(x: iconViewW + 50, y: (iconViewH - 32) / 2, width: 70, height: 32)
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
        
        for (i, icon) in icons.enumerated() {
            let x = CGFloat(i % column) * (IconImageViewW + IconImageViewSpaceHorizontal)
            let y = CGFloat(i / column) * (IconImageViewW + IconImageViewSpaceVertical) + IconImageViewSpaceVertical
            
            let iconButton = NSButton(frame: NSRect(x: x, y: y, width: IconImageViewW, height: IconImageViewW))
            iconButton.setButtonType(.momentaryLight)
            iconButton.isBordered = false
            iconButton.title = ""
            iconButton.imageScaling = .scaleProportionallyDown
            iconButton.tag = IconButtonTag + i
            iconButton.wantsLayer = true
            iconButton.layer?.backgroundColor = RGBColor(52, 53, 53).cgColor
            iconButton.toolTip = icon.use
            iconButton.target = self
            iconButton.action = #selector(iconTap(sender:))
            iconView.addSubview(iconButton)
            
            let sizeLabelX: CGFloat = x - 2
            let sizeLabelW: CGFloat = IconImageViewW + 4
            let sizeLabelH: CGFloat = 14
            let sizeLabelY: CGFloat = iconButton.frame.minY - sizeLabelH - 2
            let sizeLabel = NSText(frame: NSRect(x: sizeLabelX, y: sizeLabelY, width: sizeLabelW, height: sizeLabelH))
            sizeLabel.isEditable = false
            sizeLabel.textColor = NSColor(named: "IconImageViewSizeLabelColor")
            sizeLabel.alignment = .center
            sizeLabel.backgroundColor = NSColor.clear
            iconView.addSubview(sizeLabel)

            let size = icon.sizeString
            let scale = icon.scaleString
            sizeLabel.string = "\(size)x\(size)\(scale)"
        }
    }
    
    /// 显示图标
    /// - Parameter icons: 图标数组
    func show(icons: [BWIcon]?) {
        guard let icons = icons else { return }

        // 判断是否生成了图片,如果已生成图片,则保存按钮可以点击
        if let icon = icons.first, let _ = icon.image {
            saveButton.isEnabled = true
        }
        
        for (i, icon) in icons.enumerated() {
            guard let iconButton = iconView.viewWithTag(IconButtonTag + i) as? NSButton else {
                return
            }
            iconButton.image = icon.image
        }
    }
    
    /// 图标图片背景色适配黑暗模式
    func adaptationDarkModeFor(icons: [BWIcon]?) {
        guard let icons = icons else { return }
        
        for (i, _) in icons.enumerated() {
            guard let iconButton = iconView.viewWithTag(IconButtonTag + i) as? NSButton else {
                return
            }
            // 设置图片背景颜色
            iconButton.wantsLayer = true
            if isDarkMode() {
                iconButton.layer?.backgroundColor = RGBColor(52, 53, 53).cgColor
            } else {
                iconButton.layer?.backgroundColor = RGBColor(252, 253, 253).cgColor
            }
        }
    }
}


// MARK: - Events

extension BWIconsView {
    
    @objc func iconTap(sender: NSButton) {
        // 保存按钮不可点击,表示图标未生成,则不回调图标点击事件
        guard saveButton.isEnabled else { return }
        
        let index = sender.tag - IconButtonTag
        guard let icon = icons?[index] else { return }
        
        iconTapHandler?(icon)
    }
}
