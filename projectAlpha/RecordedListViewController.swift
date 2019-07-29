//
//  RecordedListViewController.swift
//  projectAlpha
//
//  Created by Mac on 28/07/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import FloatingPanel
import AVFoundation

class RecordedListViewController: UIViewController, UISearchBarDelegate, FloatingPanelControllerDelegate, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordedSearchBar: UISearchBar!
    @IBOutlet var recordedTableView: UITableView!
    
    var audioPlayer: AVAudioPlayer?
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    let wrapperView = UIView(frame: CGRect(x: 30, y: 200, width: 300, height: 20))
    
    var fpc: FloatingPanelController!
    var fileList: [String] = []
    
    var filemgr: FileManager!
    var dirPath: [String]!
    var docsDir: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFMSystem()
        loadData()
        recordedTableView.delegate = self
        recordedTableView.dataSource = self
        
        recordedSearchBar.delegate = self
        /* initializing audio player */
        audioPlayer?.delegate = self
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                          mode: AVAudioSession.Mode.videoRecording,
                                         options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
            try audioSession.setActive(true)
        } catch let error {
            print("audioSession properties weren't set!", error)
        }
        /* end */
    }
    
    func initFMSystem() {
        filemgr = FileManager.default
        dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = dirPath[0] as String + "/MyVocalRecorder"
    }
    
    func initPlayer(audioData: String) {
        let soundFilePath = docsDir.appending("/" + audioData)
        let soundFileURL = URL(fileURLWithPath: soundFilePath)
        
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOf: soundFileURL)
            audioPlayer?.prepareToPlay()
        } catch let err as NSError {
            print("Failed Player Initializing")
            print("ERRCODE: \(err.code) \(err.localizedDescription)")
        }
        
    }
    
    func loadData() {
        do {
            let tempFileList = try filemgr.contentsOfDirectory(atPath: docsDir)
            fileList = tempFileList
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        fpc.move(to: .full, animated: true)
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fpc.move(to: .tip, animated: true)
    }
    
    
    
    func deleteFile(fileName: String) {
        
        do {
            if filemgr.fileExists(atPath: docsDir + "/" + fileName) {
                try filemgr.removeItem(atPath: docsDir + "/" + fileName)
                print("I removed \(String(describing: docsDir))/\(fileName)")
            } else {
                print("file doesn't exist")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadData()
        return fileList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecordedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordedTableViewCell
        
        do {
            let filelist = try filemgr.contentsOfDirectory(atPath: docsDir)
            cell.fileName.text = filelist[indexPath.row]
            print(filelist[indexPath.row])
        } catch {
            print("실패")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let cell = tableView.cellForRow(at: indexPath) as? RecordedTableViewCell
            self.fileList.remove(at: indexPath.row)
            self.deleteFile(fileName: (cell?.fileName.text)!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as? RecordedTableViewCell
        initPlayer(audioData: (cell?.fileName.text)!)
        
        if let isPlaying = audioPlayer?.isPlaying {
            if isPlaying {
                audioPlayer?.stop()
            } else {
                audioPlayer?.play()
//                cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            }
        } else {
            print("audioSession is not available")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("재생종료")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
