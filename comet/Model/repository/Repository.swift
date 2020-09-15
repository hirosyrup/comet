//
//  Repository.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/07.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

protocol RepositoryNotification: class {
    func willUpdateRepository(repository: RepositoryObservable)
    func didUpdateRepository(repository: RepositoryObservable)
    func failedUpdateRepository(repository: RepositoryObservable, error: Error)
}

protocol RepositoryObservable {
    func addObserver(observer: RepositoryNotification)
    func removeObserver(observer: RepositoryNotification)
    func pullRequestDataList() -> [PullRequestData]
    func updateLogToReadAllAt(id: Int)
}

class Repository: RepositoryObservable {
    private(set) var isUpdating = false
    private var lastUpdated = Date()
    private var timer = Timer()
    
    let repositorySlug: String
    private let repositoryOwner: String
    private let userName: String
    private let password: String
    private let updateInterval: TimeInterval = 60.0
    
    private var observerList = [RepositoryNotification]()
    private var _pullRequestDataList = [PullRequestData]()
    
    init(repositoryOwner: String, repositorySlug: String, userName: String, password: String) {
        self.repositoryOwner = repositoryOwner
        self.repositorySlug = repositorySlug
        self.userName = userName
        self.password = password
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            if (!self.isUpdating && self.shouldUpdate()) {
                self.updatePullRequest()
            }
        })
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func updatePullRequest() {
        if (isUpdating) { return }
        
        isUpdating = true
        notifyWillUpdate()
        DispatchQueue.global().async {
            do {
                var pullRequestList = try self.fetchPullRequestList(merged: false)
                pullRequestList = try pullRequestList + self.fetchPullRequestList(merged: true)
                
                DispatchQueue.main.async {
                    self.lastUpdated = Date()
                    self.updateDataList(pullRequestList: pullRequestList)
                    self.isUpdating = false
                    self.notifyDidUpdate()
                }
            } catch {
                DispatchQueue.main.async {
                    print("\(error.localizedDescription)")
                    self.isUpdating = false
                    self.notifyFailedUpdate(error: error)
                }
            }
        }
    }
    
    func addObserver(observer: RepositoryNotification) {
        if observerList.firstIndex(where: { $0 === observer }) == nil {
            observerList.append(observer)
        }
    }
    
    func removeObserver(observer: RepositoryNotification) {
        if let index = observerList.firstIndex(where: { $0 === observer }) {
            observerList.remove(at: index)
        }
    }
    
    func removeAllObserver() {
        observerList.removeAll()
    }
    
    func pullRequestDataList() -> [PullRequestData] {
        return _pullRequestDataList
    }
    
    func updateLogToReadAllAt(id: Int) {
        guard let index = _pullRequestDataList.firstIndex(where: {$0.response.id == id}) else {return}
        let pullRequestData = _pullRequestDataList[index]
        UpdatePullRequestLog(data: pullRequestData).updateToReadAll()
        if pullRequestData.response.isMerged() {
            _pullRequestDataList.remove(at: index)
        }
        notifyDidUpdate()
    }
    
    private func shouldUpdate() -> Bool {
        return Date().timeIntervalSince1970 - lastUpdated.timeIntervalSince1970 >= updateInterval
    }
    
    private func fetchPullRequestList(merged: Bool) throws -> [ShowPullRequestResponse] {
        let pullRequestIndex = try CallFetchPullRequests(
            repositoryOwner: repositoryOwner,
            repositorySlug: repositorySlug,
            userName: userName,
            password: password,
            merged: merged
        ).execute()
        
        return try pullRequestIndex.values.map { (value) -> ShowPullRequestResponse in
            try CallShowPullRequest(
                id: value.id,
                repositoryOwner: repositoryOwner,
                repositorySlug: repositorySlug,
                userName: userName,
                password: password
            ).execute()
        }
    }
    
    private func notifyWillUpdate() {
        observerList.forEach { $0.willUpdateRepository(repository: self) }
    }
    
    private func notifyDidUpdate() {
        observerList.forEach { $0.didUpdateRepository(repository: self) }
    }
    
    private func notifyFailedUpdate(error: Error) {
        observerList.forEach { $0.failedUpdateRepository(repository: self, error: error) }
    }
    
    private func updateDataList(pullRequestList: [ShowPullRequestResponse]) {
        let pullRequestLog = try! PullRequestLog.all()
        _pullRequestDataList = pullRequestList.compactMap {
            var log = pullRequestLog.filter("id = \($0.id)").first
            if log == nil {
                log = createNewLog(id: $0.id, fetchedCommitHash: $0.source.commit.hash)
                if $0.isMerged() {
                    NotifyMergedPullRequest(pullRequestTitle: $0.title).notify()
                } else {
                    NotifyNewPullRequest(pullRequestTitle: $0.title).notify()
                }
            }
            
            let data = PullRequestData(log: log!, response: $0)
            
            if $0.isMerged() {
                let calcUnreadCommentCount = CalcUnreadCommentCount(data: data)
                if log!.openedCommitHash == $0.source.commit.hash && calcUnreadCommentCount.unreadCommentCount() == 0 {
                    return nil
                }
            }
            
            return data
        }
    }
    
    private func createNewLog(id: Int, fetchedCommitHash: String) -> PullRequestLog{
        return CreatePullRequestLog().createNewLog(id: id, fetchedCommitHash: fetchedCommitHash)
    }
}
