//
//  PreferencesWindowController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/08.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

protocol PreferencesWindowControllerDelegate: class {
    func willClose(vc: PreferencesWindowController)
}

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    weak var delegate: PreferencesWindowControllerDelegate?
    
    class func create() -> PreferencesWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PreferencesWindowController")
        return storyboard.instantiateController(withIdentifier: identifier) as! PreferencesWindowController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.delegate = self
    }

    func windowWillClose(_ notification: Notification) {
        delegate?.willClose(vc: self)
        NSApp.stopModal(withCode: .cancel)
        window?.orderOut(self)
    }
}
