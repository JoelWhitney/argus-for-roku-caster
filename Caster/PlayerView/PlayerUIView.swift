//
//  PlayerUIView.swift
//  Caster
//
//  Created by Joel Whitney on 2/22/20.
//  Copyright © 2020 Joel Whitney. All rights reserved.
//

import AVFoundation
import UIKit

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    var videoFeed: VideoFeed?
    
    convenience init(frame: CGRect, videoFeed: VideoFeed) {
        self.init(frame: CGRect.zero)
        self.videoFeed = videoFeed
        
        self.videoFeed = videoFeed
        let player = AVPlayer(url: videoFeed.url)
        player.play()
        
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
