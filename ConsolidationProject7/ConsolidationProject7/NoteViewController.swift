//
//  NoteViewController.swift
//  ConsolidationProject7
//
//  Created by Wbert Castro on 2/8/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    var note: Note!
    @IBOutlet var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTextView.text = note.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        note.content = noteTextView.text
    }
}
