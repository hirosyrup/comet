//
//  TextCollectionViewItem.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/08.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class TextCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var background: NSBox!
    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.addTrackingArea(NSTrackingArea(rect: view.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: view, userInfo: nil))
    }
    
    override func mouseEntered(with event: NSEvent) {
        background.fillColor = NSColor.red
    }
    
    override func mouseExited(with event: NSEvent) {
        background.fillColor = NSColor.clear
    }
    
    func setLabelText(labelText: String) {
        label.stringValue = labelText
    }
}
