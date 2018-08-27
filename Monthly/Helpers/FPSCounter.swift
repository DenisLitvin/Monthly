//
//  FPSCounter.swift
//  Catstagram-Starter
//
//  Created by Denis Litvin on 16.08.2018.
//  Copyright © 2018 Luke Parham. All rights reserved.
//

import UIKit

class FPSCounter: UIView {
    
    private var lastTime: CFTimeInterval = 0.0
    private var droppedFrames = 0
    
    let fpsCountView: UILabel
    let dropFrameView: UILabel

    init() {

        fpsCountView = {
            let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            view.isUserInteractionEnabled = false
            view.font = UIFont.boldSystemFont(ofSize: 16)
            view.textColor = .green
            view.text = "30 FPS"
            return view
        }()
        dropFrameView = {
            let view = UILabel(frame: CGRect(x: 0, y: 40, width: 100, height: 20))
            view.isUserInteractionEnabled = false
            view.font = UIFont.boldSystemFont(ofSize: 10)
            view.textColor = .green
            view.text = "10 frames dropped"
            return view
        }()

        super.init(frame: CGRect(x: 10, y: 40, width: 150, height: 60))
        self.isUserInteractionEnabled = false

        addSubview(fpsCountView)
        addSubview(dropFrameView)
        
        let link = CADisplayLink(target: self, selector: #selector(update))
        link.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func update(link: CADisplayLink) {
        if lastTime == 0.0 {
            lastTime = link.timestamp
        }
        let currentTime = link.timestamp
        let fps = String.init(format: "%.0f FPS", 1 / (link.targetTimestamp - currentTime))
        fpsCountView.text = fps
        let elapsedTime = floor((currentTime - lastTime) * 10_000) / 10_000;
//        print(elapsedTime)
//        print("et - ", elapsedTime, "duration - ", link.duration)
        if elapsedTime > link.duration  {
            droppedFrames += 1
            dropFrameView.text = "\(droppedFrames) dropped"
            print("Frame was dropped with elapsed time of \(elapsedTime) at \(currentTime)")
        }
        lastTime = link.timestamp
    }
}
