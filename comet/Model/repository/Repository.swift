//
//  Repository.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/07.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

protocol RepositoryNotification: class {
    func didUpdateRepository()
}

protocol RepositoryObservable {
    func addObserver(observer: RepositoryNotification)
    func removeObserver(observer: RepositoryNotification)
}

class Repository: RepositoryObservable {
    private var isUpdating = false
    private var lastUpdated = Date()
    private var timer = Timer()
    
    let repositorySlug: String
    private let repositoryOwner: String
    private let userName: String
    private let password: String
    private let updateInterval: TimeInterval = 60.0
    
    private var observerList = [RepositoryNotification]()
    
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
        DispatchQueue.global().async {
            do {
                defer { DispatchQueue.main.async {self.isUpdating = false} }
                
                let pullRequestList = try self.fetchPullRequestList()
                
                DispatchQueue.main.async {
                    self.lastUpdated = Date()
                    self.notifyUpdate()
                    print(pullRequestList)
                }
            } catch {
                DispatchQueue.main.async { print("\(error.localizedDescription)") }
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
    
    private func shouldUpdate() -> Bool {
        return Date().timeIntervalSince1970 - lastUpdated.timeIntervalSince1970 >= updateInterval
    }
    
    private func fetchPullRequestList() throws -> [ShowPullRequestResponse] {
        let pullRequestIndex = try CallFetchPullRequests(
            repositoryOwner: repositoryOwner,
            repositorySlug: repositorySlug,
            userName: userName,
            password: password
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
    
    private func notifyUpdate() {
        observerList.forEach { $0.didUpdateRepository() }
    }
}
