//
//  PullRequestCollectionViewSection.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/29.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class PullRequestCollectionViewSection: NSView {
    @IBOutlet weak var titleLabel: NSTextField!
    
    func setTitle(title: String) {
        titleLabel.stringValue = title
    }
}
