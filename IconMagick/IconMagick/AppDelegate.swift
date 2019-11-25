//
//  AppDelegate.swift
//  IconMagick
//
//  Created by hadlinks on 2019/11/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var shouldTeminateAppWhenClose: Bool = true


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // 1. 点击关闭按钮时,直接让应用程序退出
        // 注册 willCloseNotification 通知,然后在通知方法中退出应用程序
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWindowWillClose), name: NSWindow.willCloseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWindowWillEnterFullScreen), name: NSWindow.willEnterFullScreenNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWindowWillExitFullScreen), name: NSWindow.willExitFullScreenNotification, object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("applicationWillTerminate")
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        // 打开本应用程序 / 切换至本应用程序
        print("applicationWillBecomeActive")
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        // 点击最小化按钮 / command + H / 切换至其他应用程序
        print("applicationWillResignActive")
    }
    
    func applicationWillHide(_ notification: Notification) {
        // command + H
        print("applicationWillHide")
    }

    
    // MARK: - Custom Notification
    
    @objc func applicationWindowWillEnterFullScreen(_ aNotification: Notification) {
        print("NSWindow.willEnterFullScreenNotification")
        
        shouldTeminateAppWhenClose = true
    }
    
    @objc func applicationWindowWillExitFullScreen(_ aNotification: Notification) {
        print("NSWindow.willExitFullScreenNotification")
        
        shouldTeminateAppWhenClose = false
    }
    
    @objc func applicationWindowWillClose(_ aNotification: Notification) {
        print("NSWindow.willCloseNotification")
        
        // 解决退出全屏时,也会发送willCloseNotification通知,从而导致退出应用程序的问题
        guard shouldTeminateAppWhenClose else { return }
        
        NSApp.terminate(self)
    }
}

