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
    
    private let cellId = "PullRequestCollectionViewItem"
    private var repositoryObservable: RepositoryObservable!
    private var listItemPresenterList = [PullRequestCollectionViewItemPresenter]()
    
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
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        reloadList()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        repositoryObservable.addObserver(observer: self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        repositoryObservable.removeObserver(observer: self)
    }
    
    private func updatePresenterList() {
        listItemPresenterList = repositoryObservable.pullRequestDataList().map { PullRequestCollectionViewItemPresenter(data: $0) }
    }
    
    private func reloadList() {
        updatePresenterList()
        listView.reloadData()
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItemPresenterList.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = listView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), for: indexPath) as! PullRequestCollectionViewItem
        item.updateView(presenter: listItemPresenterList[indexPath.item])
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexpPath = indexPaths.first else { return }
        repositoryObservable.updateLogToReadAllAt(index: indexpPath.item)
        let pullRequestData = repositoryObservable.pullRequestDataList()[indexpPath.item]
        let url = CreatePullRequestUrl(id: pullRequestData.response.id).createUrl()
        NSWorkspace.shared.open(url)
        reloadList()
    }
    
    func willUpdateRepository(repository: RepositoryObservable) {
    }
    
    func didUpdateRepository(repository: RepositoryObservable) {
        reloadList()
    }
    
    func failedUpdateRepository(repository: RepositoryObservable, error: Error) {
    }
}
