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
    
    init() {
        
        // Sound resources urls
        let keyClickURL = Bundle.main.url(forResource: "click_10", withExtension: "caf")!
        
        
        do {
            self.keyClickSound = try AVAudioPlayer.init(contentsOf: keyClickURL)
//            self.keyClickSound!.delegate = (self as! AVAudioPlayerDelegate)
        } catch let error as NSError {
            print("Could not create audioPlayer \(error), \(error.userInfo)")
        }
        audioEngine = AVAudioEngine()
    }

    func playKeyClick() {
        keyClickSound.stop()
        keyClickSound.currentTime = 0
        keyClickSound.play()
    }
    
}

extension Sounds {
    static let mock = Sounds()
}
