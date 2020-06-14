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
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private let popover = NSPopover()
    private var repositoryList = [Repository]()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
            button.action = #selector(show(_:))
        }
        
        constructRepository()
        constructPopover()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func constructRepository() {
        repositoryList = [
            //Repository(repositoryOwner: "kiizan-kiizan", repositorySlug: "leeap", userName: "hirosyrup", password: "xhzc7NqWqKdExs7XYgQV")
        ]
        repositoryList.forEach {
            $0.startTimer()
            $0.updatePullRequest()
        }
    }
    
    private func constructPopover() {
        let mainViewController = MainViewController.create(repositoryList: repositoryList)
        popover.contentViewController = mainViewController
        popover.behavior = .transient
        popover.animates = false
    }
    
    @objc func show(_ sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        }
    }
}

