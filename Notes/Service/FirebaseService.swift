//
//  FirebaseService.swift
//  Notes
//
//  Created by Robin Kment on 16.05.18.
//  Copyright © 2018 cz.robinkment. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase
import Firebase

var LOGGED_USER_ID = ""

class FirebaseService {
    static let shared = FirebaseService()
    let ref = Firestore.firestore()
    typealias notesHandler = (_ notes: [Note]) -> ()
    typealias successHandler = (_ success: Bool) -> ()


    
    func getUserNotes(completetitionHandler: @escaping notesHandler) {
        ref.collection("Notes").whereField("author", isEqualTo: LOGGED_USER_ID).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [Note]()
                for document in snapshot.documents {
                    let object = try document.decode(as: Note.self)
                    objects.append(object)
                }
                completetitionHandler(objects)
                
            } catch {
                print(error)
            }
        }
    }
    
    func login(success: @escaping successHandler) {
        
        Auth.auth().signInAnonymously() { (user, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let aUser = user {
                    LOGGED_USER_ID = aUser.user.uid
                    print("Logged user id: \(LOGGED_USER_ID)")
                    success(true)
                }
            }
        }
    }
    
    func delete(id: String, successHandler: @escaping successHandler) {
        ref.collection("Notes").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                successHandler(true)
            }
        }
    }
    
    func add(note: Note, completetitionHandler: @escaping successHandler) {
        let reference = ref.collection("Notes").document()
        var docData = try! FirestoreEncoder().encode(note)
        docData["id"] = reference.documentID
        reference.setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                completetitionHandler(true)
            }
        }
    }
    
    func update(note: Note, completetitionHandler: @escaping successHandler) {
        let reference = ref.collection("Notes").document(note.id)
        let docData = try! FirestoreEncoder().encode(note)
        reference.updateData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                completetitionHandler(true)
            }
        }
    }
}

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws  -> T {
        if let data = data() {
            let object = try FirestoreDecoder().decode(objectType, from: data)
            return object
        } else {
            return T.Type.self as! T
        }
    }
    
}
