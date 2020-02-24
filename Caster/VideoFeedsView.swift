//
//  ContentView.swift
//  Caster
//
//  Created by Joel Whitney on 2/22/20.
//  Copyright © 2020 Joel Whitney. All rights reserved.
//

import SwiftUI
import SSDPClient

struct VideoFeedsView: View, SSDPDiscoveryDelegate {
    
    var videoFeeds: [VideoFeed] = []
    let client = SSDPDiscovery()
    @ObservedObject var castServicesViewModal = CastServicesViewModal()
    
    init(videoFeeds: [VideoFeed]) {
        self.videoFeeds = videoFeeds
        self.client.delegate = self
        self.client.discoverService(forDuration: 10, searchTarget: "roku:ecp")
    }
    
    var body: some View {
        NavigationView {
            List(videoFeeds) { videoFeed in
                VideoFeedCell(servicesViewModal: self.castServicesViewModal, videoFeed: videoFeed)
            }.navigationBarTitle(Text("Video feeds"))
        }.accentColor(.primary)
    }
    
    func ssdpDiscovery(_: SSDPDiscovery, didDiscoverService: SSDPService) {
        self.castServicesViewModal.addService(service: didDiscoverService)
    }
}

struct VideoFeedCell : View {
    @State var showingCastOptions = false
    @ObservedObject var servicesViewModal: CastServicesViewModal
    
    let videoFeed: VideoFeed
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(videoFeed.name)
                    .font(.headline)
                Text(videoFeed.url.absoluteString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Button(action: {
                print("Cast button tapped")
                self.showingCastOptions.toggle()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.primary)
            }.sheet(isPresented: $showingCastOptions) {
                CastOptionsView(servicesViewModal: self.servicesViewModal, videoFeed: self.videoFeed)
            }
        }
    }
}

