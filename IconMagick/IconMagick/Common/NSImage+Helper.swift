//
//  NSImage+Helper.swift
//  ImageTintAssistant-Mac
//
//  Created by hadlinks on 2019/11/21.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

extension NSImage {
    
    /**
        1. 便利构造函数 (允许返回nil)
        - 正常的构造函数一定会创建对象;
        - 判断给定的参数是否符合条件,如果不符合条件,就直接返回nil,不会创建对象,减少内存开销.

        2. 便利构造函数中使用 self.init 构造当前对象
        - 只有在便利构造函数中才调用self.init ;
        - 没有 convenience 关键字修饰的构造函数是负责创建对象的;
        - 有 convenience 关键字修饰的构造函数是用来检查条件的,本身不负责对象的创建.

        3. 如果要在便利构造函数中使用 当前对象 的属性,一定要在 self.init 之后.
    */
    
    /// 给图片添加颜色滤镜
    /// - Parameter sourceImage: 源图片
    /// - Parameter tintColor: 滤镜颜色
    convenience init?(sourceImage: NSImage, tintColor: NSColor) {
        /// NSImage的size属性:
        /// 文件名                        size
        /// xxx.png             等于实际像素大小
        /// xxx@2x.png     等于实际像素大小的一半
        /// xxx@3x.png     等于实际像素大小的1/3
        /// 以此类推...
        let size = sourceImage.size
        
        // 获取实际像素大小 (通过CGImage获取)
        var pixelSize = size
        if let cgImageRef = sourceImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            pixelSize = NSSize(width: cgImageRef.width, height: cgImageRef.height)
        }
        
        // 1. 目标图像尺寸
        // 屏幕倍数(几倍屏)
        var screenScale = NSScreen.main?.backingScaleFactor ?? 1.0
        // 在外接显示器屏幕上时,获取的screenScale为1.0,会导致处理后的图像尺寸错误,所以设置screenScale=2.0
        screenScale = 2.0
        let targetSize = NSSize(width: pixelSize.width / screenScale, height: pixelSize.height / screenScale)
        
        // 目标图像尺寸
        let targetRect = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        // 源图像尺寸
        let fromRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        
        print("size: (\(size.width), \(size.height)), size (pixel): (\(pixelSize.width), \(pixelSize.height))")
        
        // 2. 初始化图像
        self.init(size: targetSize)
        
        // 3. 创建目标图像并绘制
        // lockFocus()使用屏幕属性,普通屏幕为 72dpi,视网膜屏幕为 144dpi
        lockFocus()
        tintColor.drawSwatch(in: targetRect)
        // targetRect: 图像目标尺寸
        // fromRect: 图像源尺寸,如果传入NSZeroRect,则为整个源图像大小
        // operation: destinationOver能保留灰度信息,destinationIn能保留透明度信息
        // fraction: 图片的不透明度,范围0.0 ~ 1.0
        sourceImage.draw(in: targetRect, from: fromRect, operation: .destinationIn, fraction: 1.0)
        unlockFocus()
    }
    
    /// 给图片添加圆角
    /// - Parameter sourceImage: 源图片
    /// - Parameter radius: 圆角半径
    convenience init?(sourceImage: NSImage, radius: CGFloat) {
        let size = sourceImage.size
        
        if let cgImageRef = sourceImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            // 获取实际像素大小 (通过CGImage获取)
            let pixelSize = NSSize(width: cgImageRef.width, height: cgImageRef.height)
            
            // 1. 目标图像尺寸
            let screenScale: CGFloat = 2.0 // 屏幕倍数(几倍屏)
            let targetSize = NSSize(width: pixelSize.width / screenScale, height: pixelSize.height / screenScale)
            let targetRect = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
            
            // 2. 初始化图像
            self.init(size: targetSize)
            
            // 3. 创建目标图像并绘制
            // lockFocus()使用屏幕属性,普通屏幕为 72dpi,视网膜屏幕为 144dpi
            lockFocus()
            
            // 创建裁切路径
            let path = NSBezierPath(roundedRect: targetRect, xRadius: radius, yRadius: radius)
            // 添加裁切路径
            path.addClip()
            // 绘制图像
            let cgContext = NSGraphicsContext.current?.cgContext
            cgContext?.draw(cgImageRef, in: targetRect)
            
            unlockFocus()
        } else {
            // 初始化图像
            self.init(size: size)
        }
    }
}
