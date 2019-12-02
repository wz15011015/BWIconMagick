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
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWindowWillClose), name: NSWindow.willCloseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWindowWillEnterFullScreen), name: NSWindow.willEnterFullScreenNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWindowWillExitFullScreen), name: NSWindow.willExitFullScreenNotification, object: nil)
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

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("applicationWillTerminate")
    }
    
    /// 当关闭最后一个窗口时,退出应用程序
    /// - Parameter sender: 应用程序
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // true: 窗口 和 应用程序 都关闭
        // false: 窗口 关闭
        return true
    }

    
    // MARK: - Custom Notification
    
    /// 关闭窗口的通知 (注意: 关闭任意窗口时都会收到通知)
    /// - Parameter aNotification: 通知
    @objc func applicationWindowWillClose(_ aNotification: Notification) {
        print("NSWindow.willCloseNotification")
            
//        NSApp.terminate(self)
    }
    
    @objc func applicationWindowWillEnterFullScreen(_ aNotification: Notification) {
        print("NSWindow.willEnterFullScreenNotification")
    }
    
    @objc func applicationWindowWillExitFullScreen(_ aNotification: Notification) {
        print("NSWindow.willExitFullScreenNotification")
    }
}

