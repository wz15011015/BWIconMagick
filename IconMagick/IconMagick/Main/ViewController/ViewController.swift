//
//  ViewController.swift
//  IconMagick
//
//  Created by hadlinks on 2019/11/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var templateIconButton: NSButton!
    @IBOutlet var generateButton: NSPopUpButton!
    
    @IBOutlet var iPhoneIconView: BWIconsView!
    @IBOutlet var iPadIconView: BWIconsView!
    @IBOutlet var MacIconView: BWIconsView!
    @IBOutlet var saveiPhoneIconButton: NSButton!
    @IBOutlet var saveiPadIconButton: NSButton!
    @IBOutlet var saveMacIconButton: NSButton!
    
    private var iPhoneIcons: [BWIcon]?
    private var iPadIcons: [BWIcon]?
    private var MacIcons: [BWIcon]?
    private var templateIcon: NSImage? // 模板Icon
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         * Icon For iPhone:
         *
         *  iPhone Notification (iOS 7 - 13)
         *  20pt :  app_icon_iPhone_20x20@2x.png      40 x 40 px
         *       app_icon_iPhone_20x20@3x.png      60 x 60 px
         *
         *  iPhone Settings (iOS 7 - 13)
         *  29pt :  app_icon_iPhone_29x29@2x.png      58 x 58 px
         *       app_icon_iPhone_29x29@3x.png      87 x 87 px
         *
         *  iPhone Spotlight (iOS 7 - 13)
         *  40pt :  app_icon_iPhone_40x40@2x.png      80 x 80 px
         *       app_icon_iPhone_40x40@3x.png      120 x 120 px
         *
         *  iPhone App (iOS 7 - 13)
         *  60pt :  app_icon_iPhone_60x60@2x.png      120 x 120 px
         *       app_icon_iPhone_60x60@3x.png      180 x 180 px
         *
         *  AppStore:
         *  1024pt: app_icon_AppStore_1024x1024.png      1024 x 1024 px
         *
         *
         * Icon For iPad:
         *
         *  iPad Notification (iOS 7 - 13)
         *  20pt :  app_icon_iPad_20x20.png              20 x 20 px
         *       app_icon_iPad_20x20@2x.png      40 x 40 px
         *
         *  iPad Settings (iOS 7 - 13)
         *  29pt :  app_icon_iPad_29x29.png              29 x 29 px
         *       app_icon_iPad_29x29@2x.png      58 x 58 px
         *
         *  iPad Spotlight (iOS 7 - 13)
         *  40pt :  app_icon_iPad_40x40.png              40 x 40 px
         *       app_icon_iPad_40x40@2x.png      80 x 80 px
         *
         *  iPad App (iOS 7 - 13)
         *  76pt :  app_icon_iPad_76x76.png              76 x 76 px
         *       app_icon_iPad_76x76@2x.png      152 x 152 px
         *
         *  iPad Pro App (iOS 9 - 13)
         *  83.5pt :  app_icon_iPad_83.5x83.5@2x.png      167 x 167 px
         *
         *
         * Icon For Mac:
         *
         *  16pt :  app_icon_Mac_16x16.png                   16 x 16 px
         *       app_icon_Mac_16x16@2x.png            32 x 32 px
         *
         *  32pt :  app_icon_Mac_32x32.png                    32 x 32 px
         *       app_icon_Mac_32x32@2x.png             64 x 64 px
         *
         *  128pt :  app_icon_Mac_128x128.png               128 x 128 px
         *        app_icon_Mac_128x128@2x.png        256 x 256 px
         *
         *  256pt :  app_icon_Mac_256x256.png                256 x 256 px
         *        app_icon_Mac_256x256@2x.png        512 x 512 px
         *
         *  512pt :  app_icon_Mac_512x512.png                512 x 512 px
         *        app_icon_Mac_512x512@2x.png        1024 x 1024 px
         *
         */
        
        registerNotification()
        
        setupUI()
    }
    
    private func registerNotification() {
        // 注册窗口大小改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResize(_:)), name: NSWindow.didResizeNotification, object: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}



// MARK: - UI

extension ViewController {
    
    private func setupUI() {
        generateButton.insertItem(withTitle: "Icon For ----", at: 0)
        generateButton.selectItem(at: 0)

        saveiPhoneIconButton.isEnabled = false
        saveiPadIconButton.isEnabled = false
        saveMacIconButton.isEnabled = false
        
        templateIcon = NSImage(named: "add.png")
        
        
        // 获取图标数据
        let icons = BWIcon.loadIcons()
        iPhoneIcons = icons.0
        iPadIcons = icons.1
        MacIcons = icons.2
        
        iPhoneIconView.icons = iPhoneIcons
        iPadIconView.icons = iPadIcons
        MacIconView.icons = MacIcons
    }
}


// MARK: - Events

extension ViewController {
    
    /// 窗口大小改变的通知
    /// - Parameter notification: 通知
    @objc func windowDidResize(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }

        print(window.frame.size)
    }
    
    /// 添加模板图标
    @IBAction func addIconEvent(_ sender: NSButton) {
        // 文件打开面板
        let panel = NSOpenPanel()
        panel.prompt = "Select" // 自定义确定按钮文字
        panel.allowedFileTypes = ["png"]
        panel.allowsOtherFileTypes = false
        panel.allowsMultipleSelection = false
        panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
            if response == .OK { // 选取了文件
                guard let url = panel.urls.first,
                    let image = NSImage(contentsOfFile: url.path) else {
                    return
                }
                self.templateIconButton.image = image
                self.templateIcon = image
            }
        }
    }
    
    /// 生成图标
    @IBAction func generateIconEvent(_ sender: NSPopUpButton) {
        guard let templateIcon = templateIcon else {
            print("请添加App模板图标")
            return
        }
        
        // 根据模板图标,生成各种不同尺寸的图标,并显示
        switch sender.indexOfSelectedItem {
            case 0: ()
            
            case 1:
                iPhoneIcons?.forEach({ (icon) in
                    icon.generateIcon(with: templateIcon)
                })
                iPhoneIconView.showIcons(with: iPhoneIcons)
                saveiPhoneIconButton.isEnabled = true
            
            case 2:
                iPadIcons?.forEach({ (icon) in
                    icon.generateIcon(with: templateIcon)
                })
                iPadIconView.showIcons(with: iPadIcons)
                saveiPadIconButton.isEnabled = true
            
            case 3:
                MacIcons?.forEach({ (icon) in
                    icon.generateIcon(with: templateIcon)
                })
                MacIconView.showIcons(with: MacIcons)
                saveMacIconButton.isEnabled = true
            
            default: ()
        }
    }

    /// 导出图标
    @IBAction func saveIconEvent(_ sender: NSButton) {
        var tempIcons: [BWIcon]?
        switch sender.tag {
            case 200:
                tempIcons = iPhoneIcons
            case 201:
                tempIcons = iPadIcons
            case 202:
                tempIcons = MacIcons
            default: ()
        }
        
        guard let icons = tempIcons else {
            print("导出图标时,图标数据为空!")
            return
        }
        guard !icons.isEmpty else {
            print("导出图标时,图标数据为空!!")
            return
        }
        
        // 选择保存路径
        let panel = NSOpenPanel()
        panel.title = "请选择保存路径"
        panel.message = "保存到"
        panel.prompt = "Save"
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.directoryURL = URL(string: "~/Downloads") // 默认打开路径
        panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
            if response != .OK {
                return
            }
            
            // 选取了路径
            guard let url = panel.urls.first else {
                return
            }
            self.save(icons: icons, to: url)
        }
    }
    
    /// 保存图标到本地
    /// - Parameter icons: 图标
    /// - Parameter url: 保存路径
    private func save(icons: [BWIcon], to url: URL) {
        icons.forEach({ (icon) in
            let icon_idiom = icon.idiom ?? ""
            let icon_size = icon.sizeString
            let icon_scale = icon.scaleString
            // 生成文件名 (文件名格式为: app_icon_iPhone_20x20@2x.png)
            let imageFileName = "app_icon_\(icon_idiom)_\(icon_size)x\(icon_size)\(icon_scale).png"
            // 文件保存路径
            var imageFileURL = url
            imageFileURL.appendPathComponent(imageFileName)
            
            if icon.size == 29 && icon.scale == 1.0 {
                
                if let image = icon.image,
                    let cgImageRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                    let bitmapImageRep = NSBitmapImageRep(cgImage: cgImageRef)
                    bitmapImageRep.size = image.size
                    bitmapImageRep.pixelsWide = Int(image.size.width)
                    bitmapImageRep.pixelsHigh = Int(image.size.height)
                    let pngData = bitmapImageRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])

                    // 保存图片到本地
                    try? pngData?.write(to: imageFileURL)
                }
            }
            
        })
    }
    
    func convertCIImage(image: CIImage?, toNSImageWithSize size: NSSize) {
//        guard let image = image else { return }
//
//        let colorSpaceRef = CGColorSpaceCreateDeviceGray()
//        let contentRef = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.none.rawValue)
//
//        let context = CIContext()
//
//        let imageRef = context.createCGImage(image, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        context.scal
    }
}
