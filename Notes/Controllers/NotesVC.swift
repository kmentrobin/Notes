//
//  ViewController.swift
//  Notes
//
//  Created by Robin Kment on 16.05.18.
//  Copyright © 2018 cz.robinkment. All rights reserved.
//

import UIKit
import Firebase

class NotesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        FirebaseService.shared.login { (success) in
            self.setupData()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func setupData() {
        
        FirebaseService.shared.getUserNotes { (notes) in
            self.notes = notes.sorted(by: { $0.createdAt > $1.createdAt})
            dump(notes)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNoteBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "noteDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetail" {
            if let destination = segue.destination as? NoteDetailVC {
                destination.delegate = self
                if let sender = sender as? Note {
                    destination.note = sender
                } else {
//                    Edit
                }
            }
        }
    }
    
    @IBAction func infoBtnPressed(_ sender: UIBarButtonItem) {
        createAlert()
    }
    
    
    func createAlert() {
        let alert = UIAlertController(title: "Your id is", message: LOGGED_USER_ID, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

extension NotesVC : NoteDetailProtocol {
    func updateRequired() {
        setupData()
    }
}

extension NotesVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NoteCell
        cell.configureCell(note: notes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "noteDetail", sender: notes[indexPath.row])
    }
}

