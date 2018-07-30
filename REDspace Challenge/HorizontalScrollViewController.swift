//
//  HorizontalScrollViewController.swift
//  REDspace Challenge
//
//  Created by Michael Thompson on 2018-07-28.
//  Copyright © 2018 Michael Thompson. All rights reserved.
//

import UIKit

class HorizontalScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    let videoSources = ["https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
                        "https://cp112360-f.akamaihd.net/i/mtvnorigin/gsp.asmstor/asm/2018/07/18/NHD240349-02/NHD240349-02_,384x216_400_m30,512x288_750_m30,640x360_1200_m30,768x432_1700_m30,960x540_2200_m31,1280x720_3500_h32,.mp4.csmil/master.m3u8?__a__=off&__b__=500&__s__=on",
                        "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8"]
    
    var playerViews: [PlayerView] = []
    var currentViewIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerViews = createPlayerViews()
        configureScrollView(playerViews: playerViews)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func createPlayerViews() -> [PlayerView] {
        
        for thisSource in videoSources {
            let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView
            playerView.setUpPlayer(url: thisSource)
            playerViews.append(playerView)
        }
        
        return playerViews
    }

    func configureScrollView(playerViews: [PlayerView]) {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(playerViews.count), height: view.frame.height)
        
        for i in 0 ..< playerViews.count {
            playerViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(playerViews[i])
            
            if i == 0 {
                // start first video
                if let playerLayer = playerViews[i].playerLayer {
                    view.layer.addSublayer(playerLayer)
                    playerLayer.frame = view.frame
                    playerViews[i].play()
                }
            }
        }
    }

}

extension HorizontalScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        if pageIndex != currentViewIndex {
            
            print("--- current view index: \(currentViewIndex)")
            print("--- page index: \(pageIndex)")
            
            playerViews[currentViewIndex].pause()
            if let currentPlayerLayer = playerViews[currentViewIndex].playerLayer, let pageIndexPlayerLayer = playerViews[pageIndex].playerLayer {
                view.layer.replaceSublayer(currentPlayerLayer, with: pageIndexPlayerLayer)
                pageIndexPlayerLayer.frame = view.frame
                
                //if pageIndex < currentViewIndex {
                    playerViews[pageIndex].playFromStart()
                //} else {
                //    playerViews[pageIndex].play()
                //}
            }
            currentViewIndex = pageIndex
        }
    }
}


