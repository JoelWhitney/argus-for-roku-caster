//
//  CastOptions.swift
//  Caster
//
//  Created by Joel Whitney on 2/22/20.
//  Copyright © 2020 Joel Whitney. All rights reserved.
//

import SwiftUI
import SSDPClient

struct CastOptionsView: View {
    @ObservedObject var servicesViewModal: CastServicesViewModal
    var videoFeed: VideoFeed
    
    var body: some View {
        List(servicesViewModal.castOptions.filter( { $0.info != nil } )) { castOption in
            CastServiceCell(castOption: castOption, videoFeed: self.videoFeed)
          }.navigationBarTitle(Text("Services"))
    }
}

struct CastServiceCell: View {
    var castOption: CastOption
    var videoFeed: VideoFeed
    
    var body: some View {
        Button(action: {
            print("Row tapped!")
            
            let url = URL(string: "http://\(self.castOption.service.host):8060/launch/578841?streamformat=\(self.videoFeed.type)&url=\(self.videoFeed.url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"

                print(request)
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        
                        if let error = error {
                            print("Error took place \(error)")
                            return
                        }
                 
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            print("Response data string:\n \(dataString)")
                        }
                }
                task.resume()
        }) {
                Text(castOption.info ?? "")
                    .font(.system(size: 8))
                    .font(.subheadline)
        }
    }
}
