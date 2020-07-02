//
//  AppDelegate.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/17.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, MainViewControllerDelegate {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
            button.imagePosition = .imageLeft
            button.action = #selector(show(_:))
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {_,_ in })
        
        constructPopover()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func constructPopover() {
        let mainViewController = MainViewController.create(delegate: self)
        popover.contentViewController = mainViewController
        popover.behavior = .transient
        popover.animates = false
    }
    
    private func updateCountText(unreadCommentCount: Int, inReviewCount: Int) {
        if let button = statusItem.button {
            let presenter = AppDelegatePresenter(unreadCommentCount: unreadCommentCount, inReviewCount: inReviewCount)
            button.attributedTitle = presenter.textInStatusMenu()
        }
    }
    
    func didUpdateCount(vc: MainViewController, unreadCommentCount: Int, inReviewCount: Int) {
        updateCountText(unreadCommentCount: unreadCommentCount, inReviewCount: inReviewCount)
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

