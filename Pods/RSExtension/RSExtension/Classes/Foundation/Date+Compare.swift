//
//  Date+Compare.swift
//  MCExtension
//
//  Created by MCExtension on 2019/4/13.
//

import UIKit


public extension Date {
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    
    var isInThisWeek: Bool {
        return isInSameWeek(date: Date())
    }
    
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isInTheFuture: Bool {
        return Date() < self
    }
    
    var isInThePast: Bool {
        return self < Date()
    }
    
    /// 判断当前日期是否为今年
    func isThisYear() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let yearComps = calender.component(.year, from: self)
        // 获取现在的年份
        let nowComps = calender.component(.year, from: Date())
        
        return yearComps == nowComps
    }
    
    /// 是否是昨天
    func isYesterday() -> Bool {
        // 获取当前日历
        //        let calender = Calendar.current
        //
        //        //        return calender.isDateInYesterday(Date())
        //        //        // 获取日期的年份
        //        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        //        // 根据头条显示时间 ，我觉得可能有问题 如果comps.day == 0 显示相同，如果是 comps.day == 1 显示时间不同
        //        // 但是 comps.day == 1 才是昨天 comps.day == 2 是前天
        //        //        return comps.year == 0 && comps.month == 0 && comps.day == 1
        //        return comps.year == 0 && comps.month == 0 && (comps.day == 1 || comps.day == 0)
//        let interval = intervalDay()
//        return interval == -1
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// 是否是前天
    func isBeforeYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        //
        //        return comps.year == 0 && comps.month == 0 && comps.day == 2
        return comps.year == 0 && comps.month == 0 && comps.day == 2
    }
    
    func getLast6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }
    
    func getLast3Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)
    }
    
    func getIntervalMonth(value: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: value, to: self)
    }
    
    func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    func getTormorrow() -> Date? {
        return Calendar.current.date(byAdding: .day, value: +1, to: self)
    }
    
    func dateByAdding(day:NSInteger) -> Date? {
        return Calendar.current.date(byAdding: .day, value: +day, to: self)
    }
    
    func dateByAdding(hour:NSInteger) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: +hour, to: self)
    }
    
    func dateByAdding(year:NSInteger) -> Date? {
        return Calendar.current.date(byAdding: .year, value: +year, to: self)
    }
    
    func getLast7Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    func getLast30Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    // This Month Start
    func getThisMonthStart() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Month Start
    func getLastMonthStart() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Month End
    func getLastMonthEnd() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Next Start
    func getNextMonthStart() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Next End
    func getNextMonthEnd() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 2
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Next Start
    func getYearStartMonth() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month = 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Next End
    func getYearEndMonth() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month = 12
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    func isBeforeDate(date:Date) -> Bool {
       return   self  < date
    }
    
    func isAfterDate(date:Date) -> Bool {
        return   self  > date
    }
    
    func startOfTheDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func  startOfWeekWith(firstWeekDay:Int) -> Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = firstWeekDay
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    var getNextWeekStartOfWeek: Date? {
        let nextDay = self.dateByAdding(day:7)
        let nextWeekStart = nextDay?.startOfWeek
        return nextWeekStart
    }
    
    var getPreviousWeekStartOfWeek: Date? {
        let lassyDay = self.dateByAdding(day:-7)
        let lastWeekEnd = lassyDay?.startOfWeek
        return lastWeekEnd
    }
    
}
