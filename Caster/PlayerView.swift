//
//  PlayerView.swift
//  Caster
//
//  Created by Joel Whitney on 2/22/20.
//  Copyright © 2020 Joel Whitney. All rights reserved.
//

import SwiftUI

struct PlayerView: UIViewRepresentable {
    var videoFeed: VideoFeed
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero, videoFeed: videoFeed)
    }
}
