//
//  String+Trim.swift
//  NoteComponent
//
//  Created by tofu on 2019/1/11.
//

import UIKit

extension String {
    /// 去掉所有空格/换行
    ///
    public func trimmingAllWhitespacesAndNewlines() -> String {
        if self.isEmpty { return self }
        return self.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: " ", with: "")
    }
    
    /// 去掉首尾换行空格
    ///
    public func trimmingWhitespacesAndNewlines() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
