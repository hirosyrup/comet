//
//  NSImageView+AsyncLoad.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/19.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

extension NSImageView {
    func loadImageAsynchronously(url: URL) -> Void {
        image = nil
        DispatchQueue.global().async {
            let imageData: Data? = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let data = imageData {
                    self.image = NSImage(data: data)
                }
            }
        }
    }
}
