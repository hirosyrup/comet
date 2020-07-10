//
//  PullRequestViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa
import Moya

class PullRequestViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, RepositoryNotification, NSCollectionViewDelegateFlowLayout {
    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet weak var noPullRequestsLabel: NSTextField!
    
    private let headerId = "PullRequestCollectionViewSection"
    private let cellId = "PullRequestCollectionViewItem"
    private var repositoryObservable: RepositoryObservable!
    private var presenter = PullRequestPresenter(pullRequestDataList: [])
    
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
        
        let headerNib = NSNib(nibNamed: headerId, bundle: nil)
        let cellNib = NSNib(nibNamed: cellId, bundle: nil)
        listView.register(headerNib, forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: headerId))
        listView.register(cellNib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId))
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
        presenter = PullRequestPresenter(pullRequestDataList: repositoryObservable.pullRequestDataListWithoutMerged())
    }
    
    private func reloadList() {
        updatePresenterList()
        noPullRequestsLabel.isHidden = !presenter.sectionPresenters.isEmpty
        listView.reloadData()
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return presenter.sectionPresenters.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.sectionPresenters[section].itemPresenterList.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: view.bounds.width, height: 44.0)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 0.0, height: 40.0)
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        if kind == NSCollectionView.elementKindSectionHeader {
            let header = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: headerId), for: indexPath) as! PullRequestCollectionViewSection
            header.setTitle(title: presenter.sectionPresenters[indexPath.section].title)
            return header
        } else {
            return NSView()
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = listView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), for: indexPath) as! PullRequestCollectionViewItem
        item.updateView(presenter: presenter.sectionPresenters[indexPath.section].itemPresenterList[indexPath.item])
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        let itemPresenter = presenter.sectionPresenters[indexPath.section].itemPresenterList[indexPath.item]
        repositoryObservable.updateLogToReadAllAt(id: itemPresenter.id())
        if let url = itemPresenter.htmlLink() {
            NSWorkspace.shared.open(url)
        }
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
