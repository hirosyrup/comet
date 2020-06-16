//
//  PreferencesRepositoryInputViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/16.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa
import RealmSwift

protocol PreferencesRepositoryInputViewControllerDelegate: class {
    func willDismiss(vc: PreferencesRepositoryInputViewController)
}

class PreferencesRepositoryInputViewController: NSViewController {

    @IBOutlet weak var bitbucketUserPopUpButton: NSPopUpButton!
    @IBOutlet weak var repositoryOwnerTextField: NSTextField!
    @IBOutlet weak var repositorySlugTextField: NSTextField!
    
    private let textFieldHelper = TextFieldHelper()
    
    private weak var delegate: PreferencesRepositoryInputViewControllerDelegate?
    private var repository: RepositoryPreference!
    private var users: RealmSwift.Results<User>!
    
    class func create(repository: RepositoryPreference, delegate: PreferencesRepositoryInputViewControllerDelegate? = nil) -> PreferencesRepositoryInputViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PreferencesRepositoryInputViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! PreferencesRepositoryInputViewController
        vc.repository = repository
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repositoryOwnerTextField.delegate = textFieldHelper
        repositorySlugTextField.delegate = textFieldHelper
        
        repositoryOwnerTextField.stringValue = repository.owner
        repositorySlugTextField.stringValue = repository.slug
        
        updatePopUpList()
    }
    
    private func updatePopUpList() {
        users = try! User.all()
        bitbucketUserPopUpButton.removeAllItems()
        users.forEach { bitbucketUserPopUpButton.addItem(withTitle: $0.name) }
        if let relationUser = repository.user, let index = users.firstIndex(where: { $0.id == relationUser.id }) {
            bitbucketUserPopUpButton.select(bitbucketUserPopUpButton.item(at: index))
        }
    }
    
    @IBAction func pushCancelButton(_ sender: Any) {
        delegate?.willDismiss(vc: self)
        dismiss(self)
    }
    
    @IBAction func pushOkButton(_ sender: Any) {
        let selectedIndex = bitbucketUserPopUpButton.indexOfSelectedItem
        try! repository.save(user: users[selectedIndex], owner: repositoryOwnerTextField.stringValue, slug: repositorySlugTextField.stringValue)
        delegate?.willDismiss(vc: self)
        dismiss(self)
    }
}
