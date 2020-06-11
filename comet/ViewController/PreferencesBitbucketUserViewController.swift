//
//  PreferencesBitbucketUserViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/08.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class PreferencesBitbucketUserViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    @IBOutlet weak var listView: NSCollectionView!
    
    private let cellId = "BitbucketUserCollectionViewItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        
        let nib = NSNib(nibNamed: "TextCollectionViewItem", bundle: nil)
        listView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId))
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = listView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), for: indexPath) as! TextCollectionViewItem
        item.setLabelText(labelText: "ああああああああいいいいいいいいううううううう")
        return item
    }
}
