//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by BP  Bista on 3/28/20.
//  Copyright © 2020 BP  Bista. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: Properties

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Actions
    
    @IBAction func recordAudio(_ sender: UIButton) {
        configureRecordingUI(isRecording: true)
        record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        configureRecordingUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func record(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func configureRecordingUI(isRecording:Bool){
        if isRecording{
            recordingLabel.text = "Recording progress..."
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        }else{
            recordingLabel.text = "Tap to record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

