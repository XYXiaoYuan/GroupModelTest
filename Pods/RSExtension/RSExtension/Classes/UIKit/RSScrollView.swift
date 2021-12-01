//
//  MCScrollView.swift
//  Pods
//
//  Created by sessionCh on 2018/7/26.
//

import UIKit

/// 滑动最小单位
let gestureMinimumTranslation: CGFloat = 5.0

/// 滑动方向
enum RSPanDirection {
    case none
    case up
    case down
    case right
    case left
}

public class RSScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    fileprivate var panDirection: RSPanDirection = .none
    fileprivate var startPoint: CGPoint = .zero

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.panGestureRecognizer.addTarget(self, action: #selector(handleSwipe))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleSwipe(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        if gesture.state == .began {
            self.panDirection = .none
            self.startPoint = gesture.location(in: gesture.view)
        }
        if gesture.state == .changed {
            self.panDirection = self.determinePanDirectionIfNeeded(translation: translation)
        }
//        print("===== \(self.panDirection)")
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.panDirection == .left || self.panDirection == .up || self.panDirection == .down {
//            print("===== 2 \(self.panDirection)")
            return super.hitTest(point, with: event)
        }
        if self.panDirection == .right {
            if point.x < UIScreen.main.bounds.width - 10 {
//                print("===== 1 \(self.panDirection)")
                self.panDirection = .none
                return nil
            }
        }
//        print("===== 2 \(self.panDirection)")
        return super.hitTest(point, with: event)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.panBack(gestureRecognizer: gestureRecognizer) {
            return true
        }
        return false
    }
    
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.panBack(gestureRecognizer: gestureRecognizer) {
            return false
        }
        return true
    }
    
    //MARK: - Private Methods
    func panBack(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer, let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let point = pan.translation(in: self)
            let state = gestureRecognizer.state
            if UIGestureRecognizer.State.began == state || UIGestureRecognizer.State.possible == state {
                let location = gestureRecognizer.location(in: self)
                if point.x > 0 && location.x < UIScreen.main.bounds.width - 10 && self.contentOffset.x <= 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func determinePanDirectionIfNeeded(translation: CGPoint) -> RSPanDirection {
        if self.panDirection != .none {
            return self.panDirection
        }
        if abs(translation.x) > gestureMinimumTranslation {
            var gestureHorizontal: Bool = false
            if translation.y == 0.0 {
                gestureHorizontal = true
            } else {
                gestureHorizontal = abs(translation.x / translation.y) > 5.0
            }
            if gestureHorizontal {
                if translation.x > 0.0 {
                    return .right
                } else {
                    return .left
                }
            }
        } else if abs(translation.y) > gestureMinimumTranslation {
            var gestureHorizontal: Bool = false
            if translation.x == 0.0 {
                gestureHorizontal = true
            } else {
                gestureHorizontal = abs(translation.y / translation.x) > 5.0
            }
            if gestureHorizontal {
                if translation.y > 0.0 {
                    return .down
                } else {
                    return .up
                }
            }
        }
        return self.panDirection
    }
}

