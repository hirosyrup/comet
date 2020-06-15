//
//  PreferencesBitbucketUserViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/08.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa
import RealmSwift

class PreferencesBitbucketUserViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, PreferencesBitbucketUserInputViewControllerDelegate, TextCollectionViewItemDelegate {
    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var editButton: NSButton!
    
    private let cellId = "BitbucketUserCollectionViewItem"
    private var selectedIndex: Int? = nil
    private var users: RealmSwift.Results<User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        
        let nib = NSNib(nibNamed: "TextCollectionViewItem", bundle: nil)
        listView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId))
        
        updateButtonEnable()
        updateList()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        clearSelected()
    }
    
    private func updateButtonEnable() {
        let enabled = selectedIndex != nil
        deleteButton.isEnabled = enabled
        editButton.isEnabled = enabled
    }
    
    private func updateList() {
        users = try! User.all()
        listView.reloadData()
    }
    
    private func clearSelected() {
        selectedIndex = nil
        updateList()
        updateButtonEnable()
    }
    
    private func showInputVc(user: User) {
        let vc = PreferencesBitbucketUserInputViewController.create(user: user, delegate: self)
        presentAsSheet(vc)
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = listView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), for: indexPath) as! TextCollectionViewItem
        let user = users[indexPath.item]
        item.delegate = self
        item.isSelected = selectedIndex == indexPath.item
        item.setLabelText(labelText: user.name)
        return item
    }
    
    func willDismiss(vc: PreferencesBitbucketUserInputViewController) {
        clearSelected()
    }
    
    func didClick(view: TextCollectionViewItem) {
        if let indexPath = listView.indexPath(for: view) {
            selectedIndex = indexPath.item
            updateList()
            updateButtonEnable()
        }
    }
    
    @IBAction func pushAddButton(_ sender: Any) {
        showInputVc(user: User())
    }
    
    @IBAction func pushDeleteButton(_ sender: Any) {
        guard let index = selectedIndex else { return }
        try! users[index].delete()
        clearSelected()
    }
    
    @IBAction func pushEditButton(_ sender: Any) {
        guard let index = selectedIndex else { return }
        showInputVc(user: users[index])
    }
}
