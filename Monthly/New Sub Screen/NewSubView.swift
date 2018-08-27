//
//  NewSubView.swift
//  Monthly
//
//  Created by Denis Litvin on 26.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import RealmSwift //templocal

class NewSubView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        image = #imageLiteral(resourceName: "mock")
        let gr = UITapGestureRecognizer(target: self, action: #selector(tap))
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tap() {
        let sub = Sub()
        sub.id = UUID().uuidString
        sub.amount = 99.99
        sub.category = 2
        sub.icon = UIImageJPEGRepresentation(#imageLiteral(resourceName: "amazon"), 0.95)
        sub.firstPayout = Date().addingTimeInterval(-333499)
        sub.name = "Amazon"
        let db = DatabaseManager.init(database: try! Realm())
        db.add(sub)
        self.frame.size = .zero
    }
}
