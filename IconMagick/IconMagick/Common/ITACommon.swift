//
//  ITACommon.swift
//  ImageTintAssistant-Mac
//
//  Created by wangzhi on 2019/11/21.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa


// MARK: - 颜色

func RGBAColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> NSColor {
    return NSColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
}

func RGBColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> NSColor {
    return RGBAColor(red, green, blue, 1.0)
}


// MARK: - Dark Mode 暗黑模式判断

func isDarkMode() -> Bool {
    let appearance = NSApp.effectiveAppearance
    if #available(macOS 10.14, *) {
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == NSAppearance.Name.darkAqua
    } else {
        return false
    }
}
