//
//  RecordedListViewController.swift
//  projectAlpha
//
//  Created by Mac on 28/07/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import FloatingPanel

class RecordedListViewController: UIViewController, UISearchBarDelegate, FloatingPanelControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recordedSearchBar: UISearchBar!
    @IBOutlet var recordedTableView: UITableView!
    
    var fpc: FloatingPanelController!
    var fileList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        recordedTableView.delegate = self
        recordedTableView.dataSource = self
        
        recordedSearchBar.delegate = self
    }
    
    func loadData() {
        let filemgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0] as String + "/MyVocalRecorder"
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
        let filemgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0] as String + "/MyVocalRecorder"
        
        do {
            if filemgr.fileExists(atPath: docsDir + "/" + fileName) {
                try filemgr.removeItem(atPath: docsDir + "/" + fileName)
                print("I removed \(docsDir)/\(fileName)")
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
        let filemgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0] as String + "/MyVocalRecorder"
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
