//
//  ViewController.swift
//  projectAlpha
//
//  Created by Mac on 27/07/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import FloatingPanel
import AVFoundation

class ViewController: UIViewController, FloatingPanelControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var timer: Timer?
    var count: Int = 0
    var docsDir: String!
    
    var fpc: FloatingPanelController!

    var floatingView: RecordedListViewController!
    
    let notifiText = "버튼을 터치하여 녹음을 시작하세요!"
    let darkGrayColor = UIColor(red: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notifiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingView = storyboard?.instantiateViewController(withIdentifier: "recordedTable") as? RecordedListViewController
        
        /* Audio Recording Initializing */
        let filemgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = dirPath[0] as String + "/MyVocalRecorder"
        do {
            try filemgr.createDirectory(atPath: docsDir, withIntermediateDirectories: true, attributes: nil)
            
            print("디렉터리 생성 성공")
        } catch {
            print("디렉터리 생성 실패")
        }
        
        
        

        /* End */
        
        notifiLabel.textColor = darkGrayColor
        notifiLabel.text = notifiText
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        fpc.set(contentViewController: floatingView)
        fpc.addPanel(toParent: self)
        fpc.track(scrollView: floatingView.recordedTableView)
        fpc.move(to: .tip, animated: true)
        
        floatingView.fpc = fpc
    }
    
    @IBAction func touchUpRecordStopBtn(_ sender: UIButton) {
        
        recordStartStopAudio()
        
        if sender.isSelected {
            notifiLabel.text = notifiText
            timeLabel.text = ""
            timeLabel.textColor = .white
            fpc.move(to: .tip, animated: true)
        } else {
            notifiLabel.text = ""
            timeLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            fpc.move(to: .hidden, animated: true)
            
            if let currentTime = audioRecorder?.currentTime {
                updateTimeLabelText(time: currentTime)
            }
        }
        sender.isSelected = sender.isSelected ? false : true
    }
    
    func makeAndFireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in
            if let currentTime = self.audioRecorder?.currentTime {
                self.updateTimeLabelText(time: currentTime)
            } else {
                /* ??? */
            }
        })
        
        // 존재 이유?
        self.timer?.fire()
    }
    
    func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func updateTimeLabelText (time: TimeInterval) {
        let minutes: Int = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        timeLabel.text = String(format: "%02ld:%02ld", minutes, seconds)
    }
    
    func reloadTableView() {
        floatingView.recordedTableView?.reloadData()
    }
    
    func recordStartStopAudio() {
        
        let soundFilePath = docsDir.appending("/" + getRealTime() + ".caf")
        let soundFileURL = URL(fileURLWithPath: soundFilePath)
        
        let recordingSettings = [AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue, AVEncoderBitRateKey: 16, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0] as [String : Any]
        
        if audioRecorder == nil { // 일단 audioRecorder 인스턴스가 없을 때! 한 번만 하는 것!
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                              mode: AVAudioSession.Mode.videoRecording,
                                              options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
                try audioSession.setActive(true)
            } catch {
                print("audioSession error: \(error.localizedDescription)")
            }
            
            do {
                try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordingSettings)
                audioRecorder?.prepareToRecord()
            } catch {
                print("audioSession error: \(error.localizedDescription)")
            }
            audioRecorder?.record()
            makeAndFireTimer()
            
        } else { // 그 후
            if audioRecorder?.isRecording == false { 
                do {
                    try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordingSettings)
                    audioRecorder?.prepareToRecord()
                } catch {
                    print("audioSession error: \(error.localizedDescription)")
                }
                audioRecorder?.record()
                makeAndFireTimer()
            } else {
                audioRecorder?.stop()
                
                reloadTableView()
                invalidateTimer()
            }
        }
    }
    
    func getRealTime() -> String {
        let date = Date()
        let cal = Calendar.current
        
        let currentYear = cal.component(.year, from: date)
        let currentMonth = cal.component(.month, from: date)
        let currentDay = cal.component(.day, from: date)
        let currentHour = cal.component(.hour, from: date)
        let currentMinute = cal.component(.minute, from: date)
        let currentSecond = cal.component(.second, from: date)
        
        return String(format: "%d-%02d-%02d_%02d시 %02d분 %02d초", currentYear, currentMonth, currentDay, currentHour, currentMinute, currentSecond)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fpc.removePanelFromParent(animated: true)
    }
}

