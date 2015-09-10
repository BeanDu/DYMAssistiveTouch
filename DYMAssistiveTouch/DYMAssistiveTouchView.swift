//
//  DYMAssistiveTouchView.swift
//
//  Created by Bean on 15/8/24.
//  Copyright (c) 2015年 BeanDu. All rights reserved.
//

import UIKit

protocol DYMAssistiveTouchViewDelegate{
    func assistiveTouchViewTapAction(assistiveTouchView:DYMAssistiveTouchView)
}

let EdgeDistance:CGFloat = 5.0

class DYMAssistiveTouchView: UIImageView {
    var viewCtrl:UIViewController?
    var centerDistance:CGPoint = CGPointZero
    var startCenterPoint:CGPoint = CGPointZero
   internal var delegate:DYMAssistiveTouchViewDelegate?
    var timer:NSTimer?
    var isAppear:Bool = true
    
    //上次frame
    var lastFrame:CGRect! = CGRectMake(100,100,72,72)
    class var sharedInstance:DYMAssistiveTouchView {
        struct Singleton {
            static let instance = DYMAssistiveTouchView(frame: CGRectMake(100,100,72,72))
        }
        return Singleton.instance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target:self, action: Selector("panGestureAction:"))
        self.addGestureRecognizer(panGesture)
        
        let tapGestrue = UITapGestureRecognizer(target:self, action:Selector("tapGestureAction:"))
        self.addGestureRecognizer(tapGestrue)
        self.backgroundColor = UIColor.orangeColor()
//        self.image = UIImage(named: "")
//        self.animationImages =
//        self.layer.cornerRadius = CGRectGetWidth(frame)/2.0
//        self.clipsToBounds = true
//        self.layer.shadowColor = UIColor.blackColor().CGColor
//        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func showInViewController(viewController:UIViewController){
        if let view = DYMAssistiveTouchView.sharedInstance.superview{
            
        }else{
            if let view = viewController.view {
                view.addSubview(DYMAssistiveTouchView.sharedInstance)
            }else if let window = UIApplication.sharedApplication().keyWindow{
                window.addSubview(DYMAssistiveTouchView.sharedInstance)
            }
        }
        DYMAssistiveTouchView.disableAction()
        if CGRectEqualToRect(DYMAssistiveTouchView.sharedInstance.frame, CGRectMake(100,100,72,72)){
            DYMAssistiveTouchView.sharedInstance.center = CGPointMake(CGRectGetWidth(DYMAssistiveTouchView.sharedInstance.superview!.frame)-CGRectGetWidth(DYMAssistiveTouchView.sharedInstance.bounds)/2.0, CGRectGetHeight(DYMAssistiveTouchView.sharedInstance.superview!.frame)-CGRectGetHeight(DYMAssistiveTouchView.sharedInstance.bounds)/2.0)
        }
    }

    // : MARK
    func tapGestureAction(tapGesture:UITapGestureRecognizer){
        self.delegate?.assistiveTouchViewTapAction(self)
    }
    func panGestureAction(panGesture:UIPanGestureRecognizer){
        
        var point = panGesture.locationInView(UIApplication.sharedApplication().keyWindow!)
        if UIGestureRecognizerState.Began == panGesture.state{
            //获取点击位置与中心点在x,y方向上的距离
            self.centerDistance = CGPointMake(point.x-self.center.x, point.y-self.center.y)
            self.startCenterPoint = self.center
        }else if UIGestureRecognizerState.Changed == panGesture.state{
            var tempPoint = self.constraintAssistiveTouchViewWithPoint(point)
            self.center = CGPointMake(tempPoint.x-self.centerDistance.x, tempPoint.y-self.centerDistance.y)
            
        }else if UIGestureRecognizerState.Ended == panGesture.state{
            var tempPoint = self.constraintAssistiveTouchViewWithPoint(point)
            self.endPointFromPoint(CGPointMake(tempPoint.x-self.centerDistance.x, tempPoint.y-self.centerDistance.y))
        }else if UIGestureRecognizerState.Cancelled == panGesture.state{
            var tempPoint = self.constraintAssistiveTouchViewWithPoint(point)
            self.endPointFromPoint(CGPointMake(tempPoint.x-self.centerDistance.x, tempPoint.y-self.centerDistance.y))
        }
    }
    //约束AssistiveTouchView在屏幕之内
    func constraintAssistiveTouchViewWithPoint(point:CGPoint)->CGPoint{
        var tempPoint = point
        let minX = CGRectGetWidth(self.bounds)/2.0+EdgeDistance
        let maxX = CGRectGetWidth(self.superview!.bounds)-CGRectGetWidth(self.bounds)/2.0-EdgeDistance
        let centerFrame = CGRectMake(0,0, CGRectGetWidth(self.superview!.bounds), CGRectGetHeight(self.superview!.bounds))
        if tempPoint.x < CGRectGetMinX(centerFrame){
            tempPoint = CGPointMake(CGRectGetMinX(centerFrame), point.y)
        }else if tempPoint.x > CGRectGetMaxX(centerFrame){
            tempPoint = CGPointMake(CGRectGetMaxX(centerFrame), point.y)
        }
        if tempPoint.x < CGRectGetMinY(centerFrame){
            tempPoint = CGPointMake(point.x, CGRectGetMinY(centerFrame))
        }else if tempPoint.x > CGRectGetMaxY(centerFrame){
            tempPoint = CGPointMake(point.x, CGRectGetMaxY(centerFrame))
        }
        return tempPoint
    }
    //实现"靠边滑动"效果
    func endPointFromPoint(point:CGPoint){
        var tempPoint = point
        let centerFrame = CGRectMake(CGRectGetWidth(self.bounds)/2.0+EdgeDistance, CGRectGetHeight(self.bounds)/2.0+EdgeDistance, CGRectGetWidth(self.superview!.bounds)-CGRectGetWidth(self.bounds)-2*EdgeDistance, CGRectGetHeight(self.superview!.bounds)-CGRectGetHeight(self.bounds)-2*EdgeDistance)
        let leftSpace:CGFloat = point.x - CGRectGetMinX(centerFrame)
        let rightSpace:CGFloat = CGRectGetMaxX(centerFrame) - point.x
        let topSpace:CGFloat = point.y - CGRectGetMinY(centerFrame)
        let bottemSpace:CGFloat = CGRectGetMaxY(centerFrame) - point.y
        var distance:CGFloat = leftSpace
        if (leftSpace - rightSpace) <= 0 {
            tempPoint = CGPointMake(CGRectGetMinX(centerFrame), point.y)
        }else{
            distance = rightSpace
            tempPoint = CGPointMake(CGRectGetMaxX(centerFrame), point.y)
        }
        if bottemSpace < 50 {
            tempPoint = CGPointMake(point.x, CGRectGetMaxY(centerFrame))
        }
        if topSpace < 50 {
            tempPoint = CGPointMake(point.x, CGRectGetMinY(centerFrame))
        }
        if leftSpace < 0 {
            tempPoint = CGPointMake(CGRectGetMinX(centerFrame), tempPoint.y)
        }
        if rightSpace < 0 {
            tempPoint = CGPointMake(CGRectGetMaxX(centerFrame), tempPoint.y)
        }
        
        UIView.animateWithDuration(Double(distance/100.0), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            ()->Void in
            self.center = tempPoint
            self.transform = CGAffineTransformIdentity
            }, completion: {
                (isFinished:Bool)->Void in
                
        })
    }
    
    // MARK: -出现与消失
    
    class func didAppear(animation:Bool){
        if DYMAssistiveTouchView.sharedInstance.isAppear == true{
            return
        }
        DYMAssistiveTouchView.sharedInstance.isAppear = true
        UIView.animateWithDuration(0.3, animations: {
            ()->Void in
            DYMAssistiveTouchView.sharedInstance.alpha = 1.0
        })
    }
    class func didAppear(animation:Bool, delay:Bool){
        if DYMAssistiveTouchView.sharedInstance.isAppear == true{
            return
        }
        UIView.animateWithDuration(0.3, delay: 2, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()->Void in
            DYMAssistiveTouchView.sharedInstance.alpha = 1.0
            }, completion: {
                (isFinished:Bool)->Void in
                DYMAssistiveTouchView.sharedInstance.isAppear = true
        })
    }
    class func didDisappear(animation:Bool){
        if DYMAssistiveTouchView.sharedInstance.isAppear == false{
            return
        }
        DYMAssistiveTouchView.sharedInstance.isAppear = false
        DYMAssistiveTouchView.sharedInstance.lastFrame = DYMAssistiveTouchView.sharedInstance.frame
        UIView.animateWithDuration(0.3, animations: {
            ()->Void in
            DYMAssistiveTouchView.sharedInstance.alpha = 0.0
        })
    }
    
    class func disableAction(){
        if let temp = DYMAssistiveTouchView.sharedInstance.timer {
            DYMAssistiveTouchView.sharedInstance.timer?.invalidate()
            DYMAssistiveTouchView.sharedInstance.timer = nil
        }
    }
    class func dismiss(){
        DYMAssistiveTouchView.disableAction()
        DYMAssistiveTouchView.sharedInstance.removeFromSuperview()
    }
    func displayAnimation(){
        self.startAnimating()
    }
    
    // MARK:  -
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        NSLog("%@", NSStringFromCGPoint(point))
        if self.alpha > 0.5 {
            if CGRectContainsPoint(self.bounds, point){
                return self
            }
        }
        return super.hitTest(point, withEvent: event)
    }

}
