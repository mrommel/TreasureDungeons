//
//  OptionViewController.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 19.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

var OptionEntryCellIdentifier = "OptionEntryCell"

protocol OptionModuleInterface {
    
    func updateView()
}

protocol OptionViewInterface {
    
    func showNoPlayerMessage()
    func showPlayer(_ player: Player?)
}

class OptionViewController: UITableViewController {
    
    var presenter: OptionModuleInterface?
    
    var strongTableView : UITableView?
    @IBOutlet var noContentView : UIView!
    
    // Data
    var player: Player? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe = false
        
        let editItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(OptionViewController.didTapEditButton))
        self.navigationItem.rightBarButtonItem = editItem
        
        strongTableView = tableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.updateView()
    }
    
    func didTapEditButton() {
        //eventHandler?.addNewEntry()
    }
    
    func reloadEntries() {
        self.tableView.reloadData()
    }
}

extension OptionViewController /*: UITableViewDataSource*/ {
  
    /*override func numberOfSections(in tableView: UITableView) -> Int {

        return numberOfSections!
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        let headerImage = UIImage(named: "skull.png")
        let headerImageView = UIImageView(image: headerImage)
        headerImageView.contentMode = .scaleAspectFit
        header.backgroundView = headerImageView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionEntryCellIdentifier, for: indexPath) as UITableViewCell
        
        if let player = self.player {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = "\(player.name ?? "unknown")"
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                break
            case 1:
                cell.textLabel?.text = "Level"
                cell.detailTextLabel?.text = "\(player.level ?? 0)"
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                break
            default:
                break
            }
        }
        
        return cell
    }
    
}

extension OptionViewController: OptionViewInterface {
    
    func showPlayer(_ player: Player?) {
        
        self.player = player
        
        DispatchQueue.main.async() {
            self.reloadEntries() // need to run on ui thread
        }
    }
        
    func showNoPlayerMessage() {
        print("showNoGamePreviewsMessage")
    }
}
