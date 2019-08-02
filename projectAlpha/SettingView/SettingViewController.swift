//
//  SettingViewController.swift
//  projectAlpha
//
//  Created by Mac on 29/07/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellData: [String] = ["백그라운드 음악 설정", "녹음 설정", "테마 설정", "이 앱을 만든 사람", "문의하기"]
    let viewNameData: [String: String] = ["백그라운드 음악 설정": "bgmSettingView", "녹음 설정": "recordingSettingView", "테마 설정": "themeSettingView", "이 앱을 만든 사람": "madeByView", "문의하기": "callToView"]
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.prefersLargeTitles = true
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = indexPath.section
        switch section {
        case 0:
            cell.textLabel?.text = cellData[indexPath.row]
        case 1:
            cell.textLabel?.text = cellData[2 + indexPath.row]
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        switch section {
        case 0:
            if let view = self.storyboard?.instantiateViewController(withIdentifier: viewNameData[cellData[indexPath.row]]!) {
                navigationController?.pushViewController(view, animated: true)
                //present(view, animated: true, completion: nil)
            } else {
                print("ERROR")
            }
        case 1:
            if let view = self.storyboard?.instantiateViewController(withIdentifier: viewNameData[cellData[2 + indexPath.row]]!) {
                navigationController?.pushViewController(view, animated: true)
            } else {
                print("ERROR")
            }
        default: break
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
