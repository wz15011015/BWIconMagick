//
//  BWHUDView.swift
//  IconMagick
//
//  Created by hadlinks on 2019/12/20.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation
import Cocoa

private let BWHUDViewTag = 980665

/// HUD视图的宽度
private let BWHUDViewWidth: CGFloat = 136

/// 提示消息Label的最大高度
private let BWHUDMessageMaxHeight: CGFloat = 40


/// HUD显示状态
enum BWHUDStatus {
    case success
    case failure
}


/// BWHUDView
class BWHUDView: NSView {
    
    /// 状态图标
    private lazy var statusIcon: NSImageView = {
        let imageView = NSImageView()
        imageView.image = NSImage(named: "HUD_status_success")
        return imageView
    }()
    
    /// 提示消息Label
    private lazy var messageLabel: NSText = {
        let text = NSText()
        text.textColor = NSColor.white
        text.font = NSFont.systemFont(ofSize: 17)
        text.alignment = .center
        text.backgroundColor = NSColor.clear
        text.isVerticallyResizable = true
        return text
    }()
    
    /// 设置HUD状态
    var status: BWHUDStatus = .success {
        didSet {
            switch status {
                case .success:
                statusIcon.image = NSImage(named: "HUD_status_success")
                default:
                statusIcon.image = NSImage(named: "HUD_status_failure")
            }
        }
    }
    
    /// 消息内容
    var message: String? {
        didSet {
            guard let message = message else { return }
            messageLabel.string = message
            
            if !message.isEmpty {
                // 计算文字高度,根据文字高度调整控件位置
                let height = message.boundingRect(with: NSSize(width: BWHUDViewWidth - 10, height: BWHUDMessageMaxHeight), options: [.usesLineFragmentOrigin]).height
                if height < 20 { // 一行
                    statusIcon.frame = statusIcon.frame.offsetBy(dx: 0, dy: 12)
                    messageLabel.frame = messageLabel.frame.offsetBy(dx: 0, dy: 5)
                } else { // 两行及以上
                    statusIcon.frame = statusIcon.frame.offsetBy(dx: 0, dy: 19)
                    messageLabel.frame = messageLabel.frame.offsetBy(dx: 0, dy: 14)
                }
            }
        }
    }
    
    // MARK: Class
    /// HUD是否在显示中 (类属性使用static来修饰)
    static var isShowing: Bool = true
    
    // MARK: Override
    /// 重写tag值
    override var tag: Int {
        return BWHUDViewTag
    }
    
    
    // MARK: - Life Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(self.className) deinit")
    }
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 重载: 函数名相同,但参数和个数不同
    private init(withWindow window: NSWindow) {
        super.init(frame: NSRect.zero)
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: NSApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillBecomeActive), name: NSApplication.willBecomeActiveNotification, object: nil)
        
        setupUI(withWindow: window)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Dark Mode 适配
        var color = RGBAColor(88, 88, 88, 0.99)
        if appearanceIsDarkMode() {
            color = RGBAColor(88, 88, 88, 0.99)
        } else {
            color = RGBAColor(88, 88, 88, 0.8)
        }
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
    
    
    // MARK: - Public Class Methods
    
    /// 显示HUD
    /// - Parameter message: 消息内容, 默认为""
    /// - Parameter type: 显示类型, 默认为Success
    /// - Parameter delay: 几秒后隐藏, 默认时长为2秒
    class func show(message msg: String = "", type status: BWHUDStatus = .success, hideDelay delay: TimeInterval = 1.2) {
        guard let mainWindow = NSApp.mainWindow else { return }
        
        // 1. 初始化
        let hudView = BWHUDView(withWindow: mainWindow)
        hudView.status = status
        hudView.message = msg
        
        // 2. 添加HUD到Window
        mainWindow.contentView?.addSubview(hudView)
        
        BWHUDView.isShowing = true
        
        // 3. 1.2秒后移除HUD
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            if !BWHUDView.isShowing {
                return
            }
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
        
        BWHUDView.isShowing = false
    }
}


// MARK: - UI

extension BWHUDView {
    
    func setupUI(withWindow window: NSWindow) {
        let windowW: CGFloat = window.contentView?.frame.width ?? 0
        let windowH: CGFloat = window.contentView?.frame.height ?? 0
        
        // 1. self的设置
        let width = BWHUDViewWidth
        let height = BWHUDViewWidth
        frame = NSRect(x: (windowW - width) / 2.0, y: (windowH - height) / 2.0, width: width, height: height)
        wantsLayer = true
        layer?.backgroundColor = RGBColor(88, 88, 88).cgColor
        layer?.cornerRadius = 6
        
        // 2. 添加子控件
        addSubview(messageLabel)
        addSubview(statusIcon)
        
        let labelX: CGFloat = 5
        let labelW: CGFloat = width - (2 * labelX)
        messageLabel.frame = NSRect(x: labelX, y: 0, width: labelW, height: BWHUDMessageMaxHeight)
        messageLabel.maxSize = NSSize(width: labelW, height: BWHUDMessageMaxHeight)
        
        let iconW: CGFloat = 60
        let iconX: CGFloat = (width - iconW) * 0.5
        let iconY: CGFloat = (height - iconW) * 0.5
        statusIcon.frame = NSRect(x: iconX, y: iconY, width: iconW, height: iconW)
    }
    
    /// Dark Mode 暗黑模式判断
    func appearanceIsDarkMode() -> Bool {
        let appearance = NSApp.effectiveAppearance
        if #available(macOS 10.14, *) {
            return appearance.bestMatch(from: [.darkAqua, .aqua]) == NSAppearance.Name.darkAqua
        } else {
            return false
        }
    }
}


// MARK: - Notifications

extension BWHUDView {
    
    /// 点击最小化按钮 / command + H / 切换至其他应用程序
    /// - Parameter notification: 通知
    @objc func applicationWillResignActive(_ notification: Notification) {
        // 隐藏HUD
        BWHUDView.dismiss()
    }
    
    /// 打开本应用程序 / 切换至本应用程序
    /// - Parameter notification: 通知
    @objc func applicationWillBecomeActive(_ notification: Notification) {

    }
}
