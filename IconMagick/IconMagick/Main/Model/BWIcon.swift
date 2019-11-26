//
//  BWIcon.swift
//  IconMagick
//
//  Created by hadlinks on 2019/11/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

/// 图标模型
class BWIcon {
    
    /// 适用设备的类型
    var idiom: String?
    
    /// 大小 (pt)
    var size: Float = 0.0
    
    /// 倍数 (几倍图)
    var scale: Float = 1.0
    
    /// 用途
    var use: String?
    
    /// 适用系统版本的描述
    var system_version: String?
    
    /**
     * 1. 计算属性并不存储实际的值,而是提供一个getter和一个可选的setter
     *    来间接获取和设置其它属性
     * 2. 计算属性一般只提供getter方法
     * 3. 如果只提供getter,而不提供setter,则该计算属性为只读属性,
     *    并且可以省略get{}
     */
    /// 大小 (px)
    var size_px: Int {
        return Int(size * scale)
    }
    
    /// 字符串格式的大小
    var sizeString: String {
        var sizeString = String(format: "%.f", size)
        // 针对 83.5 的处理
        if size == 83.5 {
            sizeString = "83.5"
        }
        return sizeString
    }
    
    /// 字符串格式的倍数 (1倍为"", 2倍为"@2x", 3倍为"@3x")
    var scaleString: String {
        var scaleString = ""
        if scale == 1.0 {
            scaleString = ""
        } else {
            scaleString = "@\(Int(scale))x"
        }
        return scaleString
    }
    
    /// 图标图像
    var image: NSImage?
    
    
    init(iconInfo infoDict: [String : Any]?) {
        guard let infoDict = infoDict else { return }
        
        let idiom = infoDict["idiom"] as? String
        let size = infoDict["size"] as? Float
        let scale = infoDict["scale"] as? Float
        let use = infoDict["use"] as? String
        let system_version = infoDict["system_version"] as? String
        
        self.idiom = idiom
        if let size = size, let scale = scale {
            self.size = size
            self.scale = scale
        }
        self.use = use
        self.system_version = system_version
    }
    
    /// 根据模板图标生成图标
    /// - Parameter templateIcon: 模板图标
    func generateIcon(with templateIcon: NSImage) {
        let size = NSSize(width: size_px, height: size_px)
        image = resizeImage(sourceImage: templateIcon, toSize: size)
    }
}


extension BWIcon {
    
    /// 从plist文件加载图标数据
    class func loadIcons() -> ([BWIcon], [BWIcon], [BWIcon]) {
        var iPhoneIcons = [BWIcon]()
        var iPadIcons = [BWIcon]()
        var MacIcons = [BWIcon]()
        var icons = (iPhoneIcons, iPadIcons, MacIcons)
        
        /**
        * try的含义:
        * throws 表示会抛出异常
        *
        * 1. 方法一(推荐) try? (弱try),如果解析成功,就有值;否则为nil
        *    let array = try? JSONSerialization.jsonObject(with: , options: )
        *
        * 2. 方法二(不推荐) try! (强try),如果解析成功,就有值;否则会崩溃
        *    let array = try! JSONSerialization.jsonObject(with: , options: )
        *
        * 3. 方法三(不推荐) try 处理异常,能够接收到错误,并且输出错误
        *    do {
        *        let array = try JSONSerialization.jsonObject(with: , options: )
        *    } catch {
        *        print(error)
        *    }
        *
        * 小知识: OC中有人用 try catch吗? 为什么?
        * ARC开发环境下,编译器会自动添加 retain / release / autorelease,
        * 如果用try catch,一旦出现不平衡,就会造成内存泄漏!
        */
        
        guard let path = Bundle.main.path(forResource: "BWIconsInfo", ofType: "plist"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String : Any] else {
            return icons
        }
        
        
        if let icons = dict["iPhone"] as? [[String : Any]] {
            icons.forEach { (iconInfo) in
                iPhoneIcons.append(BWIcon(iconInfo: iconInfo))
            }
        }
        if let icons = dict["iPad"] as? [[String : Any]] {
            icons.forEach { (iconInfo) in
                iPadIcons.append(BWIcon(iconInfo: iconInfo))
            }
        }
        if let icons = dict["Mac"] as? [[String : Any]] {
            icons.forEach { (iconInfo) in
                MacIcons.append(BWIcon(iconInfo: iconInfo))
            }
        }
        icons = (iPhoneIcons, iPadIcons, MacIcons)
        
        return icons
    }
    
    
    /// 修改图片大小
    /// - Parameter sourceImage: 源图片
    /// - Parameter size: 目标大小
    func resizeImage(sourceImage image: NSImage, toSize size: CGSize) -> NSImage {
        // 1. 目标图像尺寸
        // 屏幕倍数(几倍屏)
        var screenScale = NSScreen.main?.backingScaleFactor ?? 1.0
//        if let deviceDes = NSScreen.main?.deviceDescription {
//            let screenSize = deviceDes[NSDeviceDescriptionKey.size] ?? NSSize(width: 0, height: 0) // 当前屏幕尺寸
//            let resolution = deviceDes[NSDeviceDescriptionKey.resolution] as? NSSize // 当前屏幕分辨率
//            let screenDPI = resolution?.width ?? 0 // 当前屏幕DPI
//            if screenDPI == 72 {
//                print("Current screen : scale=1, DPI=\(screenDPI), size=\(screenSize)")
//            } else if screenDPI == 144 {
//                print("Current screen : scale=2, DPI=\(screenDPI), size=\(screenSize)")
//            } else {
//                print("Current screen : scale=\(screenScale), DPI=\(screenDPI), size=\(screenSize)")
//            }
//        }
        // 在外接显示器屏幕上时,获取的screenScale为1.0,会导致尺寸错误,所以设置screenScale=2.0
        screenScale = 2.0
        let targetRect = NSRect(x: 0, y: 0, width: size.width / screenScale, height: size.height / screenScale)
        
        // 2. 获取源图像数据
        let sourceImageRep = image.bestRepresentation(for: targetRect, context: nil, hints: nil)
        
        // 3. 创建目标图像并绘制
        let targetImage = NSImage(size: targetRect.size)
        // 使用源图像数据绘制目标图像
        targetImage.lockFocus()
        sourceImageRep?.draw(in: targetRect)
        targetImage.unlockFocus()
        
        return targetImage
    }
    
    /// 修改图片大小
    /// - Parameter image: 源图片
    /// - Parameter size: 目标大小(点pt)
//    func resize(sourceImage image: NSImage, to size: NSSize) -> NSImage {
//        // 源尺寸
//        let fromRect = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//        // 目标尺寸
//        let targetRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
//
//        // 创建目标图像
//        let newImage = NSImage(size: targetRect.size)
//        // 绘制目标图像
//        newImage.lockFocus()
//        image.draw(in: targetRect, from: fromRect, operation: .copy, fraction: 1.0)
//        newImage.unlockFocus()
//
//        return newImage
//    }
    
    /// 修改图片大小
    /// - Parameter image: 源图片
    /// - Parameter size: 目标大小(像素px)
//    func resize(sourceImage image: NSImage, toPixel size: NSSize) -> NSImage {
//        // 屏幕倍数(几倍屏)
//        let screenScale = NSScreen.main?.backingScaleFactor ?? 1.0
//
//        // 源尺寸
//        let fromRect = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//        // 目标尺寸
//        let targetRect = NSRect(x: 0, y: 0, width: size.width / screenScale, height: size.height / screenScale)
//
//        // 创建目标图像
//        let newImage = NSImage(size: targetRect.size)
//        // 绘制目标图像
//        newImage.lockFocus()
//        image.draw(in: targetRect, from: fromRect, operation: .copy, fraction: 1.0)
//        newImage.unlockFocus()
//
//        return newImage
//    }
}
