//
//  TextCollectionViewItem.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/08.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

protocol TextCollectionViewItemDelegate: class {
    func didClick(view: TextCollectionViewItem)
}

class TextCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var background: NSBox!
    @IBOutlet weak var label: NSTextField!
    
    weak var delegate: TextCollectionViewItemDelegate? = nil
    
    override var isSelected: Bool {
        didSet {
            setIdleColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.addTrackingArea(NSTrackingArea(rect: view.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: view, userInfo: nil))
    }
    
    override func mouseEntered(with event: NSEvent) {
        if !isSelected {
            background.fillColor = NSColor.cellBackground
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        setIdleColor()
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.didClick(view: self)
    }
    
    func setLabelText(labelText: String) {
        label.stringValue = labelText
    }
    
    private func setIdleColor() {
        if isSelected {
            background.fillColor = NSColor.systemBlue
            label.textColor = NSColor.white
        } else {
            background.fillColor = NSColor.clear
            label.textColor = NSColor.black
        }
    }
}
