//
//  MCRegex.swift
//  MCExtension
//
//  Created by tofu on 2018/9/10.
//

import UIKit

/// 正则表达式字符
public enum RegexString: String {
    /// 国内手机号码
    case phone = "1(3|4|5|6|7|8|9)\\d{9}$|1(3|4|5|6|7|8|9){2}\\s\\d{4}\\s\\d{4}$|1(3|4|5|6|7|8|9){2}-\\d{4}-\\d{4}$"
    /// 电话号码
    case telephone = "([[+]{0,1}\\d{1,3}]{0,1}[ ]{0,1}((((\\(\\d{3,4}\\)|\\d{3,4}-|\\s)?\\d{7,14}))|((\\d{2,4}[ ]{0,1}[-]{0,1}\\d{2,4}[ ]{0,1}[-]{0,1}\\d{3,4}))))|((\\d{2,4}[ ]{0,1}[-]{0,1}\\d{2,4}[ ]{0,1}[-]{0,1}\\d{3,4}))|(\\b[19]{1}\\d{4}\\b)"
    /// 国内固定电话
    case tel = "\\d{3}-\\d{8}|\\d{4}-\\d{7}"
    /// 数字+横杠
    case phoneNum = "^[0-9-]*$"
    /// 身份证号码
    case idCard = "\\d{15}|\\d{17}[0-9Xx]"
    /// 1位小数
    case decimal1 = "^[1-9]\\d*\\.[0-9]{1}|0.[0-9]{1}$"
    /// 2位小数
    case decimal2 = "^[1-9]\\d*\\.[0-9]{2}|0.[0-9]{2}$"
    /// 3位小数
    case decimal3 = "^[1-9]\\d*\\.[0-9]{3}|0.[0-9]{3}$"
    /// 正整数
    case integer = "^[1-9]\\d*$"
    /// 全数字
    case number = "^[0-9]\\d*\\.\\d*$|^[0-9]\\d*$"
    /// 包含汉字
    case chineseIclude = "[\\u4E00-\\u9FA5]+"
    /// 包含数字
    case numberIclude = "[0-9]\\d*\\.{0,1}\\d*"
    /// 英文和数字
    case numAndCharacter = "^[A-Za-z0-9]+$"
    /// 纯英文
    case letter = "^[A-Za-z]+$"
    /// 纯数字
    case justNum = "^[0-9]*$"
    /// 英文、数字和下划线
    case chatNumberUnderline = "^[A-Za-z0-9_]+$"
    /// 米橙号 5-24个字符，以字母开头，支持使用数字和下划线
    case uniqueNumber = "^[a-zA-Z]\\w{5,23}$"
    /// 全数字严格格式（排除前置无效0)
    case numberStrict = "^([1-9]\\d*|0)\\.\\d*$|(^[1-9]\\d*|^0)$"
    /// URL
    case url = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.(([a-zA-Z]{2,5})|([0-9]{1,3}))(:\\d+)?(([\\.\\-~!@#$%^&*+?:_/=<>]+)[\\S]*)?)|([www.]{0,1}[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,5})(:\\d+)?(([\\.\\-~!@#$%^&*+?:_/=<>]+)[\\S]*)?)"
    /// 邮箱
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
}

/// 正则公用类
public struct RSRegex {
    
    fileprivate var pattern: String = "";
    
    /// 初始化正则
    ///
    /// - Parameter regex: 正则表达式
    public init(regex: RegexString) {
        self.pattern = regex.rawValue;
    }
    
    public init(regex: String) {
        self.pattern = regex
    }
    
    
    /// 匹配字符串
    ///
    /// - Parameter targetContent: 待匹配字符串
    /// - Returns: 匹配结果
    public func isMatch(targetContent: String) -> Bool {
        return self.match(string: targetContent);
    }
}

extension RSRegex {
    
    /// Matchs a string to see if it matches the regular expression pattern.
    ///
    /// - Parameters:
    ///     - string: The string that will be evaluated.
    ///     - options: Regular expression options that are applied to the string during matching. Defaults to [].
    ///
    /// - Returns: `true` if string passes the test, otherwise, `false`.
    fileprivate func match(string: String, with options: NSRegularExpression.Options = []) -> Bool {
        return evaluateForRanges(from: string, with: options).count > 0
    }
    
    /// Evaluates a string for all instances of a regular expression pattern and returns a list of matched ranges for that string.
    ///
    /// - Parameters:
    ///     - string: The string that will be evaluated.
    ///     - options: Regular expression options that are applied to the string during matching. Defaults to [].
    ///
    /// - Returns: A list of matches.
    public func evaluateForRanges(from string: String, with options: NSRegularExpression.Options = []) -> [Range<String.Index>] {
        let range = NSRange(location: 0, length: string.utf16.count)
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return []
        }
        
        let matches = regex.matches(in: string, options: [], range: range)
        
        let ranges = matches.compactMap { (match) -> Range<String.Index>? in
            let nsRange = match.range
            return nsRange.range(for: string)
        }
        
        return ranges
    }
    
    public func evaluateForNSRanges(from string: String, with options: NSRegularExpression.Options = []) -> [NSRange] {
        let range = NSRange(location: 0, length: string.utf16.count)
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return []
        }
        
        let matches = regex.matches(in: string, options: [], range: range)
        
        let ranges = matches.compactMap { (match) -> NSRange? in
            let nsRange = match.range
            return nsRange
        }
        
        return ranges
    }
}

extension NSRange {
    
    /// Converts NSRange to Range<String.Index>
    ///
    /// - Parameter string: The string from which the NSRange was extracted.
    /// - Returns: The `Range<String.Index>` representation of the NSRange.
    public func range(for string: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = string.utf16.index(string.utf16.startIndex, offsetBy: location, limitedBy: string.utf16.endIndex) else { return nil }
        guard let toUTFIndex = string.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: string.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: string) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: string) else { return nil }
        
        return fromIndex ..< toIndex
    }
}

