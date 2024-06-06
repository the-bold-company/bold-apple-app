//
//  RealmActor.swift
//
//
//  Created by Hien Tran on 17/02/2024.
//

import RealmSwift

@globalActor actor RealmActor: GlobalActor {
    static var shared = RealmActor()
}
