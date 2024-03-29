//
//  Inch.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2018/1/22.
//  Copyright © 2018年 lee. All rights reserved.
//  使用方法 1.i47(20).i55(40)

import Foundation

#if os(iOS)

import UIKit

public enum Inch {
    typealias Number = CGFloat
}

extension Inch {
    
    public enum Phone: Int, CaseIterable {
        case unknown = -1
        case i35 // iPhone2G,3G,3GS
        case i40 // iPhone5,5s,5c
        case i47 // iPhone6,6s,7,8,SE
        case i55 // 6p,6sp,7p,8P
        case i58Full // 11Pro/X/XS/iPhone12 mini
        case i61Full // iPhone11/XR
        case i65Full // 11ProMax/XSMax
        case i615G // 12/12Pro
        case i67 // 12ProMax
        
        var width: Number {
            switch self {
            case .unknown:  return 0
            case .i35:      return 320
            case .i40:      return 320
            case .i47:      return 375
            case .i55:      return 414
            case .i58Full:  return 375
            case .i61Full:  return 414
            case .i65Full:  return 414
            case .i615G:    return 390
            case .i67:      return 428
            }
        }
        
        var height: Number {
            switch self {
            case .unknown:  return 0
            case .i35:      return 480
            case .i40:      return 568
            case .i47:      return 667
            case .i55:      return 736
            case .i58Full:  return 812
            case .i61Full:  return 896
            case .i65Full:  return 896
            case .i615G:    return 844
            case .i67:      return 926
            }
        }
        
        var scale: CGFloat {
            switch self {
            case .unknown:  return 0
            case .i35:      return 2
            case .i40:      return 2
            case .i47:      return 2
            case .i55:      return 3
            case .i58Full:  return 3
            case .i61Full:  return 2
            case .i65Full:  return 3
            case .i615G:    return 3
            case .i67:      return 3
            }
        }
        
        private var size: CGSize { return CGSize(width: width, height: height) }
        private var native: CGSize { return CGSize(width: width * scale, height: height * scale) }
        
        public static func type(size: CGSize = UIScreen.main.bounds.size,
                         scale: CGFloat = UIScreen.main.scale) -> Phone {
            let width = min(size.width, size.height) * scale
            let height = max(size.width, size.height) * scale
            let size = CGSize(width: width, height: height)
            
            switch size {
            case Phone.i35.native:     return .i35
            case Phone.i40.native:     return .i40
            case Phone.i47.native:     return .i47
            case Phone.i55.native:     return .i55
            case Phone.i58Full.native: return .i58Full
            case Phone.i61Full.native: return .i61Full
            case Phone.i65Full.native: return .i65Full
            case Phone.i615G.native:   return .i615G
            case Phone.i67.native:     return .i67
            default:                   return .unknown
            }
        }
        
        public static let current: Phone = type()
    }
}

extension Inch.Phone: Equatable {
    public static func == (lhs: Inch.Phone, rhs: Inch.Phone) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Inch.Phone: Comparable {
    public static func < (lhs: Inch.Phone, rhs: Inch.Phone) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Int: Inchable {}
extension Bool: Inchable {}
extension Float: Inchable {}
extension Double: Inchable {}
extension String: Inchable {}
extension CGRect: Inchable {}
extension CGSize: Inchable {}
extension CGFloat: Inchable {}
extension CGPoint: Inchable {}
extension UIImage: Inchable {}
extension UIColor: Inchable {}
extension UIFont: Inchable {}
extension UIEdgeInsets: Inchable {}

public protocol Inchable {
    
    func i35(_ value: Self) -> Self
    func i40(_ value: Self) -> Self
    func i47(_ value: Self) -> Self
    func i55(_ value: Self) -> Self
    func i58full(_ value: Self) -> Self
    func i61full(_ value: Self) -> Self
    func i65full(_ value: Self) -> Self
    func i615G(_ value: Self) -> Self
    func i67(_ value: Self) -> Self
    
    func w320(_ value: Self) -> Self
    func w375(_ value: Self) -> Self
    func w390(_ value: Self) -> Self
    func w414(_ value: Self) -> Self
    func w428(_ value: Self) -> Self
}

extension Inchable {
    
    public func i35(_ value: Self) -> Self {
        return matching(type: .i35, value)
    }
    public func i40(_ value: Self) -> Self {
        return matching(type: .i40, value)
    }
    public func i47(_ value: Self) -> Self {
        return matching(type: .i47, value)
    }
    public func i55(_ value: Self) -> Self {
        return matching(type: .i55, value)
    }
    public func i58full(_ value: Self) -> Self {
        return matching(type: .i58Full, value)
    }
    public func i61full(_ value: Self) -> Self {
        return matching(type: .i61Full, value)
    }
    public func i65full(_ value: Self) -> Self {
        return matching(type: .i65Full, value)
    }
    public func i615G(_ value: Self) -> Self {
        return matching(type: .i615G, value)
    }
    public func i67(_ value: Self) -> Self {
        return matching(type: .i67, value)
    }
    public func ifull(_ value: Self) -> Self {
        return matching([.i58Full, .i61Full, .i65Full, .i67], value)
    }
    
    public func w320(_ value: Self) -> Self {
        return matching(width: 320, value)
    }
    public func w375(_ value: Self) -> Self {
        return matching(width: 375, value)
    }
    public func w390(_ value: Self) -> Self {
        return matching(width: 390, value)
    }
    public func w414(_ value: Self) -> Self {
        return matching(width: 414, value)
    }
    public func w428(_ value: Self) -> Self {
        return matching(width: 428, value)
    }
    
    private func matching(type: Inch.Phone, _ value: Self) -> Self {
        return Inch.Phone.current == type ? value : self
    }
    private func matching(width: Inch.Number, _ value: Self) -> Self {
        return Inch.Phone.current.width == width ? value : self
    }
    
    private func matching(_ types: [Inch.Phone], _ value: Self) -> Self {
        return types.contains(.current) ? value : self
    }
    private func matching(_ range: Range<Inch.Phone>, _ value: Self) -> Self {
        return range ~= .current ? value : self
    }
    private func matching(_ range: ClosedRange<Inch.Phone>, _ value: Self) -> Self {
        return range ~= .current ? value : self
    }
}

#endif
