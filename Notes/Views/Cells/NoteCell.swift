//
//  NoteCell.swift
//  Notes
//
//  Created by Robin Kment on 16.05.18.
//  Copyright © 2018 cz.robinkment. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    let formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        formatter.timeStyle = .short
        formatter.dateStyle = .full
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(note: Note) {
        noteLbl.text = note.text
        dateLbl.text = formatter.string(from: note.createdAt)
    }
    
}
