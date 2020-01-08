//
//  ViewController.swift
//  IconMagick
//
//  Created by hadlinks on 2019/11/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Cocoa

private let IconTableColumnID = NSUserInterfaceItemIdentifier(rawValue: "TableColumnIdentifier")

class ViewController: NSViewController {
    
    @IBOutlet var templateIconButton: NSButton!
    @IBOutlet var hintLabel: NSTextField!
    @IBOutlet var generateButton: NSPopUpButton!
    
    @IBOutlet var iconTableView: NSTableView!
    @IBOutlet var iconTableColumn: NSTableColumn!
    
    private var dataArr: [[BWIcon]?]?
    private var iconTypeArr: [BWIconType] = []
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
         *  20pt :  app_icon_iPad_20x20.png               20 x 20 px
         *       app_icon_iPad_20x20@2x.png       40 x 40 px
         *
         *  iPad Settings (iOS 7 - 13)
         *  29pt :  app_icon_iPad_29x29.png                29 x 29 px
         *       app_icon_iPad_29x29@2x.png        58 x 58 px
         *
         *  iPad Spotlight (iOS 7 - 13)
         *  40pt :  app_icon_iPad_40x40.png                40 x 40 px
         *       app_icon_iPad_40x40@2x.png        80 x 80 px
         *
         *  iPad App (iOS 7 - 13)
         *  76pt :  app_icon_iPad_76x76.png                76 x 76 px
         *       app_icon_iPad_76x76@2x.png        152 x 152 px
         *
         *  iPad Pro App (iOS 9 - 13)
         *  83.5pt :  app_icon_iPad_83.5x83.5@2x.png      167 x 167 px
         *
         *
         * Icon For Mac:
         *
         *  16pt :  app_icon_Mac_16x16.png                     16 x 16 px
         *       app_icon_Mac_16x16@2x.png              32 x 32 px
         *
         *  32pt :  app_icon_Mac_32x32.png                      32 x 32 px
         *       app_icon_Mac_32x32@2x.png              64 x 64 px
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
        
        setupData()
        
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
    
    private func setupData() {
        // 获取图标数据
        let icons = BWIcon.loadIcons()
        dataArr = [icons.0, icons.1, icons.2]
        
        iconTypeArr = [.iPhone, .iPad, .Mac]
    }
    
    private func setupUI() {
        generateButton.insertItem(withTitle: "Icon For ----", at: 0)
        generateButton.selectItem(at: 0)
        
        // 设置按钮的鼠标悬停提示文字
        templateIconButton.toolTip = NSLocalizedString("Click to add template icon", comment: "")
        
        templateIcon = NSImage(named: "add.png")
        
        iconTableColumn.identifier = IconTableColumnID
        iconTableView.backgroundColor = NSColor.clear
    }
}


// MARK: - Events

extension ViewController {
    
    /// 窗口大小改变的通知
    /// - Parameter notification: 通知
    @objc func windowDidResize(_ notification: Notification) {
//        guard let window = notification.object as? NSWindow else { return }

//        print(window.frame.size)
    }
    
    /// 添加模板图标
    @IBAction func addIconEvent(_ sender: NSButton) {
        // 文件打开面板
        let panel = NSOpenPanel()
        panel.message = NSLocalizedString("Please select a template icon (requires size 1024x1024)", comment: "")
        panel.prompt = NSLocalizedString("Select", comment: "") // 自定义确定按钮文字
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
                
                // 判断模板图标大小是否符合要求,不符合时,修改提示文字
                let size = image.size
                
                /// NSImage的size属性:
                /// 文件名                        size
                /// xxx.png             等于实际像素大小
                /// xxx@2x.png     等于实际像素大小的一半
                /// xxx@3x.png     等于实际像素大小的1/3
                /// 以此类推...
                // 获取实际像素大小 (通过CGImage获取)
                var pixelSize = size
                if let cgImageRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                    pixelSize = NSSize(width: cgImageRef.width, height: cgImageRef.height)
                }
                
                if pixelSize.equalTo(NSSize(width: 1024, height: 1024)) {
                    self.hintLabel.stringValue = NSLocalizedString("Meet 1024x1024 size", comment: "")
                    self.hintLabel.textColor = NSColor.systemGreen
                } else {
                    self.hintLabel.stringValue = NSLocalizedString("Require 1024x1024 size", comment: "")
                    self.hintLabel.textColor = NSColor.systemRed
                }
            }
        }
    }
    
    /// 生成图标
    @IBAction func generateIconEvent(_ sender: NSPopUpButton) {
        guard let templateIcon = templateIcon else {
            print("Please add App template icon")
            return
        }
        
        var icons: [BWIcon]?
        // 根据模板图标,生成各种不同尺寸的图标,并显示
        switch sender.indexOfSelectedItem {
            case 0: ()
            case 1:
                icons = dataArr?[0]
            case 2:
                icons = dataArr?[1]
            case 3:
                icons = dataArr?[2]
            default: ()
        }
        icons?.forEach({ (icon) in
            icon.generateIcon(with: templateIcon)
        })
        
        // 刷新图标显示
        iconTableView.reloadData()
    }

    /// 导出图标
    func saveIconEvent(_ iconType: BWIconType) {
        var folderName = "IconMagick-icons" // 文件夹名称
        var tempIcons: [BWIcon]?
        switch iconType {
            case .iPhone:
                folderName = "IconMagick-iPhone-icons"
                tempIcons = dataArr?[0]
            case .iPad:
                folderName = "IconMagick-iPad-icons"
                tempIcons = dataArr?[1]
            default:
                folderName = "IconMagick-Mac-icons"
                tempIcons = dataArr?[2]
        }
        
        guard let icons = tempIcons else {
            print("When exporting icons, the icon data is empty!")
            return
        }
        guard !icons.isEmpty else {
            print("When exporting icons, the icon data is empty!!")
            return
        }
        
        // Choose a save path
//        let panel = NSOpenPanel()
//        panel.title = NSLocalizedString("Please choose a save path", comment: "")
//        panel.message = NSLocalizedString("Save icons to", comment: "")
//        panel.prompt = NSLocalizedString("Save", comment: "")
//        panel.canChooseDirectories = true
//        panel.canChooseFiles = false
//        panel.canCreateDirectories = true
//        panel.directoryURL = URL(string: "~/Downloads") // Open path by default
//        panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
//            if response != .OK {
//                return
//            }
//            // Path selected
//            guard let url = panel.urls.first else {
//                return
//            }
//        }
        
        
        // Choose a save path
        let panel = NSSavePanel()
        panel.title = NSLocalizedString("Please choose a save path", comment: "")
        panel.message = NSLocalizedString("Save icons to folder", comment: "")
        panel.prompt = NSLocalizedString("Save", comment: "")
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = folderName
        panel.directoryURL = URL(string: "~/Downloads") // Open path by default
        panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
            if response != .OK {
                return
            }
            // Path selected
            guard let url = panel.url else {
                return
            }
            
            // 创建文件夹
            let fileManager = FileManager.default
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

            icons.forEach({ (icon) in
                let icon_idiom = icon.idiom ?? ""
                let icon_size = icon.sizeString
                let icon_scale = icon.scaleString
                // 生成文件名 (文件名格式为: app_icon_iPhone_20x20@2x.png)
                let imageFileName = "app_icon_\(icon_idiom)_\(icon_size)x\(icon_size)\(icon_scale).png"
                // 文件保存路径
                var imageFileURL = url
                imageFileURL.appendPathComponent(imageFileName)

                self.save(image: icon.image, to: imageFileURL)
            })
            
            BWHUDView.show(message: NSLocalizedString("Success", comment: ""))
        }
    }
    
    /// 导出单个图标
    func saveSingleIcon(_ icon: BWIcon) {
        let icon_idiom = icon.idiom ?? ""
        let icon_size = icon.sizeString
        let icon_scale = icon.scaleString
        // 生成文件名 (文件名格式为: app_icon_iPhone_20x20@2x.png)
        let imageFileName = "app_icon_\(icon_idiom)_\(icon_size)x\(icon_size)\(icon_scale).png"
        
        let panel = NSSavePanel()
        panel.message = NSLocalizedString("Save icons as", comment: "")
        panel.prompt = NSLocalizedString("Save", comment: "")
        panel.nameFieldStringValue = imageFileName
        panel.canCreateDirectories = true
        panel.allowedFileTypes = ["png"]
        panel.beginSheetModal(for: NSApp.mainWindow!) { (response: NSApplication.ModalResponse) in
            if response != .OK {
                return
            }
            // Path selected
            guard let url = panel.url else {
                return
            }
            
            self.save(image: icon.image, to: url)
            
            if let _ = icon.image {
                BWHUDView.show(message: NSLocalizedString("Success", comment: ""))
            }
        }
    }
    
    /// 保存图片到本地
    /// - Parameters:
    ///   - image: 图片
    ///   - url: 本地路径
    private func save(image: NSImage?, to url: URL?) {
        if let image = image,
            let url = url,
            let cgImageRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            
            let bitmapImageRep = NSBitmapImageRep(cgImage: cgImageRef)
            let pngData = bitmapImageRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
            // 保存图片到本地
            try? pngData?.write(to: url)
        }
    }
}


extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return BWIconsViewH
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let columnID = tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: "")
        if columnID == IconTableColumnID {
            var view = tableView.makeView(withIdentifier: columnID, owner: self) as? BWIconsView
            if view == nil {
                view = BWIconsView()
            }
            view?.iconType = iconTypeArr[row]
            view?.icons = dataArr?[row]
            view?.show(icons: dataArr?[row])
            
            view?.iconSaveHandler = { (iconType) in
                self.saveIconEvent(iconType)
            }
            view?.iconTapHandler = { (icon) in
                self.saveSingleIcon(icon)
            }
            return view
        }
        
        return nil
    }
}
