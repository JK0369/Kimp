//
//  PostTaskManager.swift
//  Domain
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import UIKit

public enum PostTaskType {
    case showToast(message: String)
    case opinion(message: String)
    case checkVersion
}

public enum PostTaskTarget {
    case splash
    case profileMain
    case home
    case rating
    case history
}

public struct PostTask {
    let target: PostTaskTarget
    let task: PostTaskType

    public init(target: PostTaskTarget, task: PostTaskType) {
        self.target = target
        self.task = task
    }
}

public class PostTaskManager {

    public init() {}

    private var postTasks = [PostTaskTarget: [PostTaskType]]()

    public func register(postTask: PostTask) {
        guard postTasks[postTask.target] != nil else {
            postTasks[postTask.target] = [postTask.task]
            return
        }

        postTasks[postTask.target]?.append(postTask.task)
    }

    public func postTasks(postTastTarget: PostTaskTarget) -> [PostTaskType]? {
        if isExist(taskTarget: postTastTarget) {
            return postTasks[postTastTarget]
        } else {
            return nil
        }
    }

    public func removeAll() {
        postTasks.removeAll()
    }

    public func remove(for input: PostTaskTarget) {
        postTasks[input]?.removeAll()
    }

    private func isExist(taskTarget: PostTaskTarget) -> Bool {
        return !(postTasks[taskTarget]?.isEmpty ?? true)
    }
}
