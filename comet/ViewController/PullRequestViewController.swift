//
//  PullRequestViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa
import Moya

class PullRequestViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet weak var label: NSTextField!
    
    private let cellId = "PullRequestCollectionViewItem"
    
    class func create() -> PullRequestViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PullRequestViewController")
        return storyboard.instantiateController(withIdentifier: identifier) as! PullRequestViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        
        let nib = NSNib(nibNamed: "PullRequestCollectionViewItem", bundle: nil)
        listView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId))
        
        label.stringValue = title ?? ""
        
        fetch()
    }
    
    private func fetch() {
        DispatchQueue.global().async {
            do {
                let result = try CallFetchPullRequests(repositoryOwner: "kiizan-kiizan", repositorySlug: "leeap", userName: "hirosyrup", password: "xhzc7NqWqKdExs7XYgQV").execute()
                
                DispatchQueue.main.async {
                    print(result)
                }
            } catch {
                DispatchQueue.main.async { print("\(error.localizedDescription)") }
            }
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = listView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), for: indexPath) as! PullRequestCollectionViewItem
        return item
    }
}
