//
//  RecordSoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Derrick Price on 3/11/15.
//  Copyright (c) 2015 Derrick Price. All rights reserved.
//

import UIKit
import AVFoundation

//Declared Globally
var audioRecorder:AVAudioRecorder!
var recordedAudio:RecordedAudio!

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Outlet variables to handle the buttons and labels on the app
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordingButtonOutlet: UIButton!
    @IBOutlet weak var stopRecodingButton: UIButton!
    @IBOutlet weak var tapMicrophoneLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the stop recording button
        stopRecodingButton.hidden = true;
        // Enable the recording button
        recordingButtonOutlet.enabled = true;
        // Hide text to illustrate tapping the microphone
        tapMicrophoneLabelOutlet.hidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func StopRecord(sender: UIButton) {
        // Show text for recording in process
        recordingInProgress.hidden = true;
        // Hide the stop recording button
        stopRecodingButton.hidden = true;
        // Enable the recording button
        recordingButtonOutlet.enabled = true;
        
        //Inside func stopAudio(sender: UIButton)
        // Stop the audio recorder
        audioRecorder.stop();
        // Inactivate the audio session
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }

    @IBAction func RecordAudio(sender: UIButton) {
        // Begin audio recording - show the recording in progress label and stop button
        recordingInProgress.hidden = false;
        stopRecodingButton.hidden = false;
        // Hide label tip, and disable record button
        tapMicrophoneLabelOutlet.hidden = true;
        recordingButtonOutlet.enabled = false;
        
        //Inside func recordAudio(sender: UIButton)
        // Build path and file name for storing recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String;
        
        let currentDateTime = NSDate();
        let formatter = NSDateFormatter();
        formatter.dateFormat = "ddMMyyyy-HHmmss";
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav";
        let pathArray = [dirPath, recordingName];
        let filePath = NSURL.fileURLWithPathComponents(pathArray);
        println(filePath);
        
        // Create the audio session for recording
        var session = AVAudioSession.sharedInstance();
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil);
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil);
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord();
        // Start recording
        audioRecorder.record();
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag)
        {
            // Upon successful recording set global variable for components of recording
            recordedAudio = RecordedAudio(filepath:recorder.url, filetitle:recorder.url.lastPathComponent);
            recordedAudio.filePathURL = recorder.url;
            recordedAudio.title = recorder.url.lastPathComponent;
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio);
        }
        else
        {
            // Recording failed, reset buttons
            recordingButtonOutlet.enabled = true;
            stopRecodingButton.hidden = true;
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording")
        {
            // Using the proper segue, pass recorded audio components to other play sounds view.
            let playSoundsVC:playSoundsViewController = segue.destinationViewController as playSoundsViewController;
            let data = sender as RecordedAudio;
            playSoundsVC.receivedAudio = data;
        }
    }
}

