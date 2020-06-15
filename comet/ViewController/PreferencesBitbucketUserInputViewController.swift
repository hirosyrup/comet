//
//  PreferencesBitbucketUserInputViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/15.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

protocol PreferencesBitbucketUserInputViewControllerDelegate: class {
    func willDismiss(vc: PreferencesBitbucketUserInputViewController)
}

class PreferencesBitbucketUserInputViewController: NSViewController {

    @IBOutlet weak var userNameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    private let textFieldHelper = TextFieldHelper()
    private var user: User!
    private weak var delegate: PreferencesBitbucketUserInputViewControllerDelegate?
    
    class func create(user: User, delegate: PreferencesBitbucketUserInputViewControllerDelegate? = nil) -> PreferencesBitbucketUserInputViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PreferencesBitbucketUserInputViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! PreferencesBitbucketUserInputViewController
        vc.user = user
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = textFieldHelper
        passwordTextField.delegate = textFieldHelper
        
        userNameTextField.stringValue = user.name
        passwordTextField.stringValue = user.password
    }
    
    @IBAction func pushCancelButton(_ sender: Any) {
        delegate?.willDismiss(vc: self)
        dismiss(self)
    }
    
    @IBAction func pushOkButton(_ sender: Any) {
        try! user.save(name: userNameTextField.stringValue, password: userNameTextField.stringValue)
        delegate?.willDismiss(vc: self)
        dismiss(self)
    }
}
