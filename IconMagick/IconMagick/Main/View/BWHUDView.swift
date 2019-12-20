//
//  BWHUDView.swift
//  IconMagick
//
//  Created by hadlinks on 2019/12/20.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation
import Cocoa

let BWHUDViewTag = 980665


class BWHUDView: NSView {
    
    /// 提示图标
    private lazy var statusIcon: NSImageView = {
        let imageView = NSImageView()
        return imageView
    }()
    
    /// 提示消息
    private lazy var messageLabel: NSText = {
        let text = NSText()
        text.textColor = NSColor.white
        text.font = NSFont.systemFont(ofSize: 18)
        text.alignment = .center
        text.backgroundColor = NSColor.clear
        return text
    }()
    
    
    /// 重写tag值
    override var tag: Int {
        return BWHUDViewTag
    }
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    init(with window: NSWindow) {
        super.init(frame: NSRect.zero)
        
        setupUI(with: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Methods
    
    /// 显示HUD
    /// - Parameter delay: 几秒后隐藏, 默认时长为2秒
    class func show(hideDelay delay: TimeInterval = 1.2) {
        guard let mainWindow = NSApp.mainWindow else { return }
        
        // 1. 初始化
        let hudView = BWHUDView(with: mainWindow)
        
        // 2. 添加HUD到Window
        mainWindow.contentView?.addSubview(hudView)
        
        // 3. 3秒后移除HUD
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            BWHUDView.dismiss()
        }
    }
    
    /// 隐藏HUD
    class func dismiss() {
        guard let mainWindow = NSApp.mainWindow,
            let hudView = mainWindow.contentView?.viewWithTag(BWHUDViewTag) as? BWHUDView else {
            return
        }
        // 移除HUD视图
        hudView.removeFromSuperview()
    }
}


// MARK: - UI
extension BWHUDView {
    
    func setupUI(with window: NSWindow) {
        let windowW: CGFloat = window.contentView?.frame.width ?? 0
        let windowH: CGFloat = window.contentView?.frame.height ?? 0
        
        let width: CGFloat = 136
        let height: CGFloat = 136
        self.frame = NSRect(x: (windowW - width) / 2.0, y: (windowH - height) / 2.0, width: width, height: height)
        self.wantsLayer = true
        self.layer?.backgroundColor = RGBColor(88, 88, 88).cgColor
        self.layer?.cornerRadius = 8
        
        
        // 添加子控件
        addSubview(messageLabel)
        addSubview(statusIcon)
        
        let labelX: CGFloat = 5
        let labelW: CGFloat = width - (2 * labelX)
        let labelY: CGFloat = height * 0.18
        messageLabel.frame = NSRect(x: labelX, y: labelY, width: labelW, height: 20)
        
        let iconW: CGFloat = 60
        let iconX: CGFloat = (width - iconW) / 2.0
        let iconY: CGFloat = messageLabel.frame.maxY + 6
        statusIcon.frame = NSRect(x: iconX, y: iconY, width: iconW, height: iconW)
        
        
        messageLabel.string = "Success"
        statusIcon.image = NSImage(named: "HUD_status_success")
    }
}
