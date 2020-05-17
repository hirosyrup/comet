//
//  AppDelegate.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/17.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let mainViewController = MainViewController.create()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
            button.action = #selector(showMenu(_:))
        }
        
        constructMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func constructMenu() {
        let menu = NSMenu()
        let menuItem = NSMenuItem()
        menuItem.view = mainViewController.view
        
        menu.addItem(menuItem)
        
        statusItem.menu = menu
    }
    
    @objc func showMenu(_ sender: Any?) {
        
    }
}

