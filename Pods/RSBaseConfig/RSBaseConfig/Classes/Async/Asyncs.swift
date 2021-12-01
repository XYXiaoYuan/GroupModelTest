//
//  Asyncs.swift
//  RSBaseConfig
//
//  Created by 袁小荣 on 2020/7/16.
//

import Foundation

public struct Asyncs {
    public typealias Task = () -> Void
    
    /// 异步在子线程执行任务
    /// - Parameter task: 在子线程的任务
    public static func async(_ task: @escaping Task) {
        _async(task)
    }
    
    /// 异步在子线程执行任务
    /// - Parameters:
    ///   - task: 在子线程的任务
    ///   - mainTask: 子线程任务完毕后,需要在主线程执行的任务
    public static func async(_ task: @escaping Task,
                             _ mainTask: @escaping Task) {
        _async(task, mainTask)
    }
}

private extension Asyncs {
    static func _async(_ task: @escaping Task,
                       _ mainTask: Task? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
}

/// 延迟
public extension Asyncs {
    
    /// 主线程延迟任务
    /// - Parameters:
    ///   - seconds: 延迟秒数
    ///   - task: 延迟的主线程任务
    @discardableResult
    static func delay(_ seconds: TimeInterval,
                             _ task: @escaping Task) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.main.delay(seconds, execute: task)
        return item
    }
            
    /// 子线程延迟任务
    /// - Parameters:
    ///   - seconds: 延迟秒数
    ///   - task: 延迟的子线程任务
    @discardableResult
    static func asyncDelaySub(_ seconds: TimeInterval,
                                     _ task: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, DispatchQueue.global(), task)
    }
    
    /// 子线程延迟任务
    /// - Parameters:
    ///   - seconds: 延迟秒数
    ///   - task: 延迟的子线程任务
    ///   - mainTask: 延迟子线程任务执行完毕后,需要在主线程执行的任务
    @discardableResult
    static func asyncDelaySub(_ seconds: TimeInterval,
                                     _ task: @escaping Task,
                                     _ mainTask: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, DispatchQueue.global(), task, mainTask)
    }
}

private extension Asyncs {
    @discardableResult
    static func _asyncDelay(_ seconds: TimeInterval,
                            _ queue: DispatchQueue,
                            _ task: @escaping Task,
                            _ mainTask: Task? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        queue.delay(seconds, execute: task)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        /// 返回item是因为可以随时取消任务
        return item
    }
}

public extension DispatchQueue {
    func delay(_ seconds: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + seconds, execute: closure)
    }
    
    private static var _onceTracker = [String]()
    class func once(block:()->Void) {
        let token = UUID().uuidString
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
