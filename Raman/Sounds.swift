//
//  Sounds.swift
//  Raman
//
//  Created by Denis Ricard on 2018-09-07.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class Sounds {
    
//    private var newValueSound: AVAudioPlayer!
//    private var deleteRowSound: AVAudioPlayer!
    private var keyClickSound: AVAudioPlayer!
//    private var popSound: AVAudioPlayer!
    var audioEngine: AVAudioEngine!

    private var keyClickBuffer: Int = 0
    
    init() {
        
        // Sound resources urls
        let keyClickURL = Bundle.main.url(forResource: "click_10", withExtension: "caf")!
        
        
        do {
            self.keyClickSound = try AVAudioPlayer.init(contentsOf: keyClickURL)
            self.keyClickSound!.delegate = (self as! AVAudioPlayerDelegate)
        } catch let error as NSError {
            print("Could not create audioPlayer \(error), \(error.userInfo)")
        }
        audioEngine = AVAudioEngine()
    }

    func playKeyClick() {
        keyClickBuffer += 1
        print("Increasing buffer: \(keyClickBuffer)")
        if keyClickBuffer == 1 {
            // this is the first time we press a key, so start the first sound
            // the others will come from didFinish
            keyClickSound.play()
            print("Playing first sound")
        }
    }

}

extension Sounds {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        keyClickBuffer -= 1
        print("Decreasing buffer: \(keyClickBuffer)")
        if keyClickBuffer > 0 {
            keyClickSound.play()
            print("Playing sound #\(keyClickBuffer + 1)")
        }
    }
}

extension Sounds {
    static let mock = Sounds()
}
