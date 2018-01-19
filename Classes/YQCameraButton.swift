//
//  YQCameraButton.swift
//  YQCameraButton
//
//  Created by Wang on 2018/1/16.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

private let kDuration: CFTimeInterval = 0.15
private let kSpace: CGFloat = 2

public enum YQCameraButtonType {
    case photo
    case video
}

@IBDesignable

public class YQCameraButton: UIControl {

    private let insideLayer: CAShapeLayer = CAShapeLayer()
    private let outsideLayer: CAShapeLayer = CAShapeLayer()
    private let _intrinsicContentSize = CGSize(width: 30, height: 30)
    fileprivate var animationNewProperties: (CGRect, CGFloat)?
    private var lineWidth: CGFloat = 6

    private var _isHighlighted = false {
        didSet {
            self.insideLayer.opacity = _isHighlighted ? 0.5 : 1
        }
    }
    fileprivate var _isSelected = false {
        didSet {
            isSelected = _isSelected
            resetLayersPath()
        }
    }
    
    
    public var yq: YQCameraButtonContainer {
        return YQCameraButtonContainer(self)
    }
    
    public var type: YQCameraButtonType = .photo {
        didSet {
            switch type {
            case .photo:
                self.insideLayer.backgroundColor = UIColor.white.cgColor
            case .video:
                self.insideLayer.backgroundColor = UIColor.red.cgColor
            }
        }
    }
   
    // MARK: - 初始化相关
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: _intrinsicContentSize.width, height: _intrinsicContentSize.height))
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
       
    }
    
    func commonInit() {
        outsideLayer.fillColor = UIColor.clear.cgColor
        outsideLayer.strokeColor = UIColor.white.cgColor
        outsideLayer.lineWidth = lineWidth
        insideLayer.backgroundColor = type == .photo ? UIColor.white.cgColor : UIColor.red.cgColor
//        insideLayer.masksToBounds = true
        layer.addSublayer(outsideLayer)
        layer.addSublayer(insideLayer)
        resetLayersPath()
        isUserInteractionEnabled = true
    }
    
    func resetLayersPath() {
        assert(bounds.width == bounds.height, "当前视图的长宽不相等,请重新设置")
        outsideLayer.frame = self.bounds
        insideLayer.frame = self.bounds.insetBy(dx: lineWidth + kSpace, dy: lineWidth + kSpace)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = bounds.width / 2 - lineWidth / 2 - kSpace
        outsideLayer.path = UIBezierPath(arcCenter: center, radius: bounds.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false).cgPath
        if type == .photo {
            insideLayer.cornerRadius = radius
        } else if type == .video {
            let oldBounds = insideLayer.bounds
            var newBounds = oldBounds
            if isSelected {
                newBounds.size.width = radius
                newBounds.size.height = radius
            } else {
                newBounds.size.width = radius * 2
                newBounds.size.height = radius * 2
            }
            
            let oldCornerRadius = insideLayer.cornerRadius
            let newCornerRadius: CGFloat = isSelected ? 4 : radius

            var animations: [CABasicAnimation] = []
            if newBounds != oldBounds {
                let animation = CABasicAnimation(keyPath: "bounds")
                animation.fromValue = oldBounds
                animation.toValue = newBounds
                animations.append(animation)
            }
            if newCornerRadius != oldCornerRadius {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.fromValue = oldCornerRadius
                animation.toValue = newCornerRadius
                animations.append(animation)
            }
            let group = CAAnimationGroup()
            group.animations = animations
            group.duration = kDuration
            group.delegate = self
            group.isRemovedOnCompletion = true
            insideLayer.bounds = newBounds
            insideLayer.cornerRadius = newCornerRadius
            insideLayer.add(group, forKey: "animation")
            animationNewProperties = (newBounds, newCornerRadius)
            
        }
    }

    
    override public func layoutSubviews() {
        super.layoutSubviews()
        resetLayersPath()
    }
    
    override public var intrinsicContentSize: CGSize {
        return _intrinsicContentSize
    }
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)
        _isHighlighted = true
        return result
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        _isHighlighted = false
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        _isHighlighted = false
    }
    
//    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        guard let superview = self.superview else {
//            return nil
//        }
//        if superview.convert(self.bounds, from: nil).contains(point) {
//            return self
//        }
//        return nil
//    }
}


// MARK: - Delegate
extension YQCameraButton: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let properties = animationNewProperties, flag else {return}
//        insideLayer.bounds = properties.0
//        insideLayer.cornerRadius = properties.1
    }
}

public class YQCameraButtonContainer {
    let base: YQCameraButton
    public var isSelected: Bool {
        set {
            base._isSelected = newValue
        }
        get {
            return base._isSelected
        }
    }
    
    init(_ base: YQCameraButton) {
        self.base = base
    }
}
