//
//  PreferencesRepositoryViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/16.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa
import RealmSwift

class PreferencesRepositoryViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, PreferencesRepositoryInputViewControllerDelegate, TextCollectionViewItemDelegate {

    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var editButton: NSButton!
    
    private let cellId = "RepositoryCollectionViewItem"
    private var selectedIndex: Int? = nil
    private var repositories: RealmSwift.Results<RepositoryPreference>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = NSNib(nibNamed: "TextCollectionViewItem", bundle: nil)
        listView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId))
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        listView.delegate = self
        listView.dataSource = self
        clearSelected()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        listView.delegate = nil
        listView.dataSource = nil
    }
    
    private func showInputVc(repository: RepositoryPreference) {
        let vc = PreferencesRepositoryInputViewController.create(repository: repository, delegate: self)
        presentAsSheet(vc)
    }
    
    private func updateButtonEnable() {
        let enabled = selectedIndex != nil
        deleteButton.isEnabled = enabled
        editButton.isEnabled = enabled
    }
    
    private func updateList() {
        repositories = try! RepositoryPreference.all()
        listView.reloadData()
    }
    
    private func clearSelected() {
        selectedIndex = nil
        updateList()
        updateButtonEnable()
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = listView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), for: indexPath) as! TextCollectionViewItem
        let repository = repositories[indexPath.item]
        item.delegate = self
        item.isSelected = selectedIndex == indexPath.item
        item.setLabelText(labelText: repository.slug)
        return item
    }
    
    func willDismiss(vc: PreferencesRepositoryInputViewController) {
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
        showInputVc(repository: RepositoryPreference())
    }
    
    @IBAction func pushDeleteButton(_ sender: Any) {
        guard let index = selectedIndex else { return }
        try! repositories[index].delete()
        clearSelected()
    }
    
    @IBAction func pushEditButton(_ sender: Any) {
        guard let index = selectedIndex else { return }
        showInputVc(repository: repositories[index])
    }
}
