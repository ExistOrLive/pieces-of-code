//
//  ZMTurntableView.swift
//  PandaNuggets
//
//  Created by 朱猛 on 2019/7/20.
//  Copyright © 2019 zm. All rights reserved.
//

import UIKit



@objc enum ZMTurntableViewStatus: Int
{
    case notRun             //! 未启动
    case accelerating       //! 加速
    case decelerating       //! 减速
    case maxSpeed           //! 最大速度
}

@objc protocol ZMTurntableViewDelegate : NSObjectProtocol
{
    func onZMTurntableViewStatusWillBeRotated(turnTableView:ZMTurntableView) -> Bool;
    
    func onZMTurntableViewStatusWillBeMaxSpeed(turnTableView:ZMTurntableView);
    
    func onZMTurntableViewStatusWillBeStopped(turnTableView:ZMTurntableView);
}

@objcMembers class ZMTurntableView: UIView {

    weak var delegate : ZMTurntableViewDelegate?
    @IBOutlet weak var turntbaleImageView: UIImageView!
    
    @IBOutlet weak var turntableButton: UIButton!
    
    private var timer : CADisplayLink?
    private var angle : CGFloat = 0.0
    private var speed : Int = 100
    private(set) var status : ZMTurntableViewStatus = .notRun
    private var stopStartAngle : CGFloat = -1.0
    private var stopAngleSize : CGFloat = -1.0

    
    var acceleratedSpeed : Int = 50  //！ 默认加速度为10帧达到最大速度
    
    var deceleratedSpeed : Int = 0 - 1 //! 减速度
    
    var maxSpeed : Int = 10          //! 默认最大速度10帧一圈
    
    var initSpeed : Int = 100    //! 初始速度 100 帧一圈
    
    deinit {
        
    }
    
    func startRotate()
    {
        if self.status != .notRun
        {
            return
        }
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(ZMTurntableViewDelegate.onZMTurntableViewStatusWillBeRotated(turnTableView:)))
        {
            if false == self.delegate!.onZMTurntableViewStatusWillBeRotated(turnTableView: self)
            {
                return
            }
        }
        
        self.speed = self.initSpeed
        self.status = .accelerating
        self.startTimer()
        
    }
    
    func endRotate(stopStartAngle: CGFloat, stopAngleSize : CGFloat)
    {
        if self.status != .maxSpeed
        {
            return
        }
        self.status = .decelerating
        self.stopStartAngle = stopStartAngle
        self.stopAngleSize = stopAngleSize
    }
    
    func destoryView()
    {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func rotateTurntable(displayLink :CADisplayLink )
    {
        //  计算当前速度
        var currentSpeed = self.speed
        
        switch self.status
        {
        case .notRun: do{
            self.stopTimer()
            return;
            }
        case .accelerating: do{
            currentSpeed = self.speed - self.acceleratedSpeed
            if currentSpeed <= self.maxSpeed
            {
                if self.delegate != nil && self.delegate!.responds(to: #selector(ZMTurntableViewDelegate.onZMTurntableViewStatusWillBeMaxSpeed(turnTableView:)))
                {
                   self.delegate!.onZMTurntableViewStatusWillBeMaxSpeed(turnTableView: self)
                }
                currentSpeed = self.maxSpeed
                self.speed = self.maxSpeed
                self.status = .maxSpeed
            }
            }
        case .decelerating: do{
            currentSpeed = self.speed + self.acceleratedSpeed
            if currentSpeed >= self.initSpeed
            {
                currentSpeed = self.initSpeed
                self.speed = self.initSpeed
            }
            }
        case .maxSpeed: do{
            break;
            }
        }
        
        self.speed = currentSpeed;
        self.angle = CGFloat(Double.pi) * 2 / CGFloat(currentSpeed) + self.angle
        
        while(self.angle >= CGFloat(Double.pi) * 2 )
        {
            self.angle = self.angle - CGFloat(Double.pi) * 2
        }
        
        let transform = CGAffineTransform.init(rotationAngle: self.angle);
        self.turntbaleImageView.layer.setAffineTransform(transform)
        
        // 到达目标范围，停止转动
        if self.angle >= self.stopStartAngle && self.angle <= (self.stopAngleSize + self.stopStartAngle)
        {
            if self.delegate != nil && self.delegate!.responds(to: #selector(ZMTurntableViewDelegate.onZMTurntableViewStatusWillBeStopped(turnTableView:)))
            {
                self.delegate!.onZMTurntableViewStatusWillBeStopped(turnTableView: self)
            }
            
            self.status = .notRun;
            self.stopStartAngle = -1.0
            self.stopAngleSize = -1.0
        }
    }
    
    
    @IBAction func onTurntableButtonClicked(_ sender: Any) {
        
        switch self.status
        {
        case .notRun: do{
            self.startRotate()
            }
        case .accelerating: do{
            break;
            }
        case .decelerating: do{
            break;
            }
        case .maxSpeed: do{
//            self.endRotate(stopStartAngle: CGFloat(Double.pi) / 3 +  CGFloat(Double.pi) / 30, stopAngleSize: CGFloat(Double.pi) / 6 -  CGFloat(Double.pi) / 15)
            break;
            }
        }
        
    }
    
    func startTimer()
    {
        self.timer = CADisplayLink.init(target: self, selector: #selector(rotateTurntable(displayLink:)))
        self.timer?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func stopTimer()
    {
        self.timer?.invalidate()
        self.timer = nil
    }
}
