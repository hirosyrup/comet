//
//  Sequence+JoinedAttributeString.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/07/03.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == NSAttributedString {
    func joined(with separator: NSAttributedString) -> NSAttributedString {
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if r.length > 0 {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }

    func joined(with separator: String = "") -> NSAttributedString {
        return self.joined(with: NSAttributedString(string: separator))
    }
}
