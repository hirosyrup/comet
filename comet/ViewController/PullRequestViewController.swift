//
//  PullRequestViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa
import Moya

class PullRequestViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, RepositoryNotification {
    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet weak var label: NSTextField!
    
    private let cellId = "PullRequestCollectionViewItem"
    private var repositoryObservable: RepositoryObservable!
    
    class func create(repositoryObservable: RepositoryObservable) -> PullRequestViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PullRequestViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! PullRequestViewController
        vc.repositoryObservable = repositoryObservable
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        
        let nib = NSNib(nibNamed: "PullRequestCollectionViewItem", bundle: nil)
        listView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId))
        
        label.stringValue = title ?? ""
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        repositoryObservable.addObserver(observer: self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        repositoryObservable.removeObserver(observer: self)
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = listView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), for: indexPath) as! PullRequestCollectionViewItem
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    }
    
    func didUpdateRepository() {
        print("updated")
    }
}
