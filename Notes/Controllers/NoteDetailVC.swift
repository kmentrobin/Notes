//
//  NoteDetailVC.swift
//  Notes
//
//  Created by Robin Kment on 16.05.18.
//  Copyright © 2018 cz.robinkment. All rights reserved.
//

import UIKit

protocol NoteDetailProtocol {
    func updateRequired()
}
class NoteDetailVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var delegate : NoteDetailProtocol?
    
    @IBOutlet weak var removeBtn: UIBarButtonItem!
    let placeholder = "Enter your note".localized
    
    var note : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let note = note {
            removeBtn.isEnabled = true
            textView.text = note.text
        } else {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            textView.becomeFirstResponder()
            removeBtn.isEnabled = false
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        textView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNoteBtnPressed(_ sender: UIBarButtonItem) {
        if var note = note {
            if textView.text != placeholder && textView.text != "" && textView.text != nil {
                note.text = textView.text
                FirebaseService.shared.update(note: note) { (success) in
                    print("Successfully written!")
                    self.delegate?.updateRequired()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            if textView.text != placeholder && textView.text != "" && textView.text != nil {
                let note = Note(text: textView.text)
                FirebaseService.shared.add(note: note) { (success) in
                    print("Successfully written!")
                    self.delegate?.updateRequired()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        if let note = note {
            FirebaseService.shared.delete(id: note.id) { (success) in
                self.delegate?.updateRequired()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension NoteDetailVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
