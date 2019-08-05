//
//  BgmSettingViewController.swift
//  projectAlpha
//
//  Created by Mac on 29/07/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class BgmSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bgmTableView: UITableView!
    
    var fileList: [String] = []
    var filemgr: FileManager!
    var dirPath: [String]!
    var docsDir: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initFMSystem()
        loadData()
        
        bgmTableView.delegate = self
        bgmTableView.dataSource = self
    }
    
    func initFMSystem() {
        filemgr = FileManager.default
        dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = dirPath[0] as String
    }
    
    func loadData() {
        do {
            let tempFileList = try filemgr.contentsOfDirectory(atPath: docsDir)
            fileList = tempFileList
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fileList[indexPath.row]
        
        if BGM.sharedInstance.doesBGMExist && (BGM.sharedInstance.getBGMFileName() == cell.textLabel?.text) {
            BGM.sharedInstance.selectedCell = cell
            cell.accessoryType = .checkmark
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if BGM.sharedInstance.doesBGMExist {
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                BGM.sharedInstance.destroyBGM()
            } else {
                BGM.sharedInstance.destroyBGM()
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                
                if let temp = tableView.cellForRow(at: indexPath)?.textLabel?.text {
                    BGM.sharedInstance.setBGM(temp)
                    print(temp)
                    BGM.sharedInstance.selectedCell = tableView.cellForRow(at: indexPath)
                } else {
                    print("BGM Setting Error")
                }
            }
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
            if let temp = tableView.cellForRow(at: indexPath)?.textLabel?.text {
                BGM.sharedInstance.setBGM(temp)
                print(temp)
                BGM.sharedInstance.selectedCell = tableView.cellForRow(at: indexPath)
            } else {
                print("BGM Setting Error")
            }
        }
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
