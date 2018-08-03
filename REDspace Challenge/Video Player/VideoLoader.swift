//
//  VideoMgr.swift
//  REDspace Challenge
//
//  Created by Michael Thompson on 2018-07-31.
//  Copyright © 2018 Michael Thompson. All rights reserved.
//

import Foundation
import AVKit

class VideoLoader {

    let videoSourceUrls = ["https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
                        "https://cp112360-f.akamaihd.net/i/mtvnorigin/gsp.asmstor/asm/2018/07/18/NHD240349-02/NHD240349-02_,384x216_400_m30,512x288_750_m30,640x360_1200_m30,768x432_1700_m30,960x540_2200_m31,1280x720_3500_h32,.mp4.csmil/master.m3u8?__a__=off&__b__=500&__s__=on",
                        "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
                        "https://cp112360-f.akamaihd.net/i/mtvnorigin/gsp.asmstor/asm/2018/07/18/NHD240349-02/NHD240349-02_,384x216_400_m30,512x288_750_m30,640x360_1200_m30,768x432_1700_m30,960x540_2200_m31,1280x720_3500_h32,.mp4.csmil/master.m3u8?__a__=off&__b__=500&__s__=on",
                        "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8"]
    
    func loadAssets(completion: @escaping ([AVAsset])->()) {
        
        var results: [AVAsset] = []
        let dispatchGroup = DispatchGroup()
        let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
        
        for url in videoSourceUrls {
            guard let url = URL(string: url) else { return }
            
            let asset = AVAsset(url: url)
            let playableKey = "playable"
            //let metaKey = "availableMetadataFormats"
            
            dispatchGroup.enter()
            asset.loadValuesAsynchronously(forKeys: [playableKey]) {
                var error: NSError? = nil
                let status = asset.statusOfValue(forKey: playableKey, error: &error)
                switch status {
                case .loaded:
                    accessQueue.async(flags:.barrier) {
                        results.append(asset)
                        //print("--- Sucessfully loaded so add to list: \(results.count)")
                    }
                    
                case .failed:
                    self.handleAssetLoadingProblem()
                case .cancelled:
                    self.handleAssetLoadingProblem()
                default:
                    self.handleAssetLoadingProblem()
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(results)
        }
    }
    
    func handleAssetLoadingProblem() {
        DispatchQueue.main.async {
            // just a token/placeholder handler
            print("--- something bad happened. Perhaps tell the user or log it?")
        }
    }

}
