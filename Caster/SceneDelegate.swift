//
//  SceneDelegate.swift
//  Caster
//
//  Created by Joel Whitney on 2/22/20.
//  Copyright © 2020 Joel Whitney. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: VideoFeedsView(videoFeeds: sampleVideoFeeds))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    // GET URL FROM LINK HERE
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let link = URLContexts.first?.url else {
            return
        }
        
        let components = URLComponents(url: link, resolvingAgainstBaseURL: false)
        if let comp = components, let queryItems = comp.queryItems, let host = queryItems.filter( {$0.name == "host" } ).first?.value, let type = queryItems.filter( {$0.name == "streamformat" } ).first?.value, let url = queryItems.filter( {$0.name == "url" } ).first?.value {
            let rokuLink = URL(string: "http://\(host):8060/launch/578841?streamformat=\(type)&url=\(url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
            print(link)
            print(rokuLink!)
            
            var request = URLRequest(url: rokuLink!)
            request.httpMethod = "POST"
                
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
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

