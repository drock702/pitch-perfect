//
//  playSoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Derrick Price on 3/18/15.
//  Copyright (c) 2015 Derrick Price. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundsViewController: UIViewController {

    // Variables for the audio playbac
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioTimePitch:AVAudioUnitTimePitch!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var error:NSError?
        audioPlayer = AVAudioPlayer (contentsOfURL: receivedAudio.filePathURL, error: &error);
        audioPlayer.enableRate = true;
        
        //Audio Engine is initialized in viewDidLoad()
        audioEngine = AVAudioEngine();
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Generic function for playing audio at given rate
    func playRecording (playrate: Float)
    {
        // Reset the audio player, and play the audio at the given reate
        audioPlayer.stop ();
        audioPlayer.currentTime = 0.0;
        audioPlayer.rate = playrate;
        audioPlayer.play();
    }

    @IBAction func playSlowRecording(sender: UIButton) {
        
        audioEngine.stop();
        audioEngine.reset();
        playRecording (0.5);
    }
    
    @IBAction func playFastRecording(sender: UIButton) {
        
        audioEngine.stop();
        audioEngine.reset();
        playRecording (2.0);
    }
    
    @IBAction func playChimpmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000);
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000);
    }
    
    // Function for playing with various pitches
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop();
        audioEngine.stop();
        audioEngine.reset();
        
        var audioPlayerNode = AVAudioPlayerNode();
        audioEngine.attachNode(audioPlayerNode);
        
        var changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = pitch;
        audioEngine.attachNode(changePitchEffect);
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil);
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil);
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil);
        audioEngine.startAndReturnError(nil);
        
        audioPlayerNode.play();
    }
    
    @IBAction func stopPlayingRecording(sender: UIButton) {
        audioPlayer.stop ();
        audioPlayer.currentTime = 0.0;
        audioEngine.stop();
        audioEngine.reset();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
