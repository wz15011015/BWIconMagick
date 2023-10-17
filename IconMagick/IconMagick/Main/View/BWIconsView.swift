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
    case Watch
}


// 图标视图的初始Tag值
private let IconButtonTag = 100

/// 图标的宽高
private let IconImageViewW: CGFloat = 84.0
/// 图标的水平间距
private let IconImageViewSpaceHorizontal: CGFloat = 8.0
/// 图标的竖直间距
private let IconImageViewSpaceVertical: CGFloat = 18.0

/// 类型图片的宽高
private let TypeImageViewW: CGFloat = 36.0
/// 类型图片底部间距
private let TypeImageViewBottomSpace: CGFloat = 8.0
/// 类型名称的高
private let TypeNameLabelH: CGFloat = 18.0


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
    
    /// 类型图片
    private var typeImageView: NSImageView = {
        let view = NSImageView()
        return view
    }()
    
    /// 类型名称
    private var typeNameLabel: NSText = {
        let text = NSText()
        text.textColor = NSColor.white
        text.font = NSFont.systemFont(ofSize: 17)
//        text.alignment = .left
        text.isSelectable = false
        text.backgroundColor = NSColor.clear
//        text.isVerticallyResizable = true
        text.minSize = CGSize(width: 80.0, height: TypeNameLabelH)
        return text
    }()
    
    var icons: [BWIcon]? {
        didSet {
            guard let icons = icons else { return }

            addIconImageViews(icons: icons)
        }
    }
    
    /// 图标类型
    var iconType: BWIconType = .iPhone {
        didSet {
            layout()
        }
    }
    
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
    
    
    // MARK: Tools
    
    /// 计算视图整体高度
    /// - Parameter iconType: 视图图标类型
    /// - Returns: 高度
    class func calcViewHeight(with iconType: BWIconType) -> CGFloat {
        var row = 2.0 // 行数
        switch iconType {
            case .iPhone:
                row = 4.0
            case .Watch:
                row = 4.0
            default:
                row = 2.0
        }
        let height = ((IconImageViewW * row) + (IconImageViewSpaceVertical * row) + TypeImageViewW + TypeImageViewBottomSpace)
        return height
    }
}


// MARK: - UI

extension BWIconsView {
    
    override func layout() {
        super.layout()
        
        // 2行 5列
        var row = 2.0
        let column = 5.0
        switch iconType {
            case .iPhone:
                row = 4.0
            case .Watch:
                row = 4.0
            default:
                row = 2.0
        }
        let iconViewW = (IconImageViewW * column) + (IconImageViewSpaceHorizontal * (column - 1))
        let iconViewH = (IconImageViewW * row) + (IconImageViewSpaceVertical * row)
        // 视图高度
        let viewHeight = BWIconsView.calcViewHeight(with: iconType)
        
        iconView.frame = CGRect(x: 0, y: 0, width: iconViewW, height: iconViewH)
        saveButton.frame = CGRect(x: iconViewW + 50, y: (iconViewH - 32) / 2, width: 70, height: 32)
        
        // 类型图片&名称
        typeImageView.frame = CGRect(x: 0, y: viewHeight - TypeImageViewW, width: TypeImageViewW, height: TypeImageViewW)
        typeNameLabel.frame = CGRect(x: TypeImageViewW + 5, y: typeImageView.frame.minY + (TypeImageViewW - TypeNameLabelH) * 0.5, width: 80.0, height: TypeNameLabelH)
    }
    
    private func setupUI() {
        saveButton.target = self
        
        addSubview(iconView)
        addSubview(saveButton)
        addSubview(typeImageView)
        addSubview(typeNameLabel)
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
        // 显示类型图片及名称
        switch iconType {
            case .iPhone:
                typeImageView.image = NSImage(named: "type_iPhone_icon")
                typeNameLabel.string = "iPhone"
            case .iPad:
                typeImageView.image = NSImage(named: "type_iPad_icon")
                typeNameLabel.string = "iPad"
            case .Mac:
                typeImageView.image = NSImage(named: "type_Mac_icon")
                typeNameLabel.string = "Mac"
            case .Watch:
                typeImageView.image = NSImage(named: "type_Watch_icon")
                typeNameLabel.string = "Watch"
        }
        
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
        // 类型名称颜色
        if isDarkMode() {
            typeNameLabel.textColor = NSColor.white
        } else {
            typeNameLabel.textColor = NSColor.black
        }
        
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
