//
//  TextFieldHelper.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/16.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class TextFieldHelper: NSObject, NSTextFieldDelegate {
    var allowPaste = true
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if allowPaste && isPasteCommand(commandSelector: commandSelector) {
            paste(textView: textView)
            return true
        }
        
        return false
    }
    
    private func isPasteCommand(commandSelector: Selector) -> Bool {
        return commandSelector == Selector(("noop:")) && NSApp.currentEvent?.keyCode == 9
    }
    
    private func paste(textView: NSTextView) {
        guard let range = (textView.selectedRanges.first as? NSRange) else { return }
        let clipboardText = NSPasteboard.general.string(forType: .string) ?? ""
        let text = textView.string as NSString
        textView.string = text.replacingCharacters(in: range, with: clipboardText)
    }
}
