//
//  DataModels.swift
//  Caster
//
//  Created by Joel Whitney on 2/23/20.
//  Copyright © 2020 Joel Whitney. All rights reserved.
//

import Foundation
import SwiftUI
import SSDPClient

struct VideoFeed: Identifiable {
    var id = UUID()
    var name: String
    var type: String
    var url: URL
}

#if DEBUG
let sampleVideoFeeds = [
    VideoFeed(name: "MP4 sample", type: "mp4", url: URL(string: "http://video.ted.com/talks/podcast/VilayanurRamachandran_2007_480.mp4")!),
    VideoFeed(name: "M3U8 sample", type: "hls", url: URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!)
]
#endif

class CastServicesViewModal: ObservableObject {
    @Published var castOptions = [CastOption]()

    func addService(service: SSDPService){
        DispatchQueue.main.async {
            if !self.castOptions.contains(where: { $0.service == service }) {
                self.castOptions.append(CastOption(service: service))
                print("New service found: \(service.host). New count = \(self.castOptions.count)")
            }
        }
    }
    
    func removeCastOption(castOption: CastOption) {
        castOptions.removeAll(where: {$0.id == castOption.id} )
    }
}

class CastOption: NSObject, Identifiable, XMLParserDelegate {
    var id = UUID()
    var service: SSDPService
    var info: String?
    
    var elementName: String = String()
    var name = String()
    var location = String()
    
    init(service: SSDPService) {
        self.service = service
        super.init()
        getInfo()
    }
    
    func getInfo() {
        let url = URL(string: "http://\(self.service.host):8060/query/device-info")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

            print(request)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
             
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string:\n \(dataString)")
                        let parser = XMLParser(data: data)
                        parser.delegate = self
                        parser.parse()
                        
                        self.info = dataString
                    }
            }
            task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "friend-device-name" {
            name = String()
        } else if elementName == "user-device-location" {
            location = String()
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "friend-device-name" {
                name += data
            } else if self.elementName == "user-device-location" {
                location += data
            }
        }
    }
}


extension SSDPService: Equatable {
    public static func ==(lhs: SSDPService, rhs: SSDPService) -> Bool {
        return lhs.host == rhs.host
    }

}
