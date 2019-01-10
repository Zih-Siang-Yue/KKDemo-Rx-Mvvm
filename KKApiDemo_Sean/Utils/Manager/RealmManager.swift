//
//  RealmManager.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/26.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol RealmManagerProtocol {
    var realm: Realm { get }
}

enum RealmError: String, Error {
    case OpenFailure = "Open realm failure"
}

class RealmManager: RealmManagerProtocol {  //TODO: 可以設計在指定線程中做存取(另外創建其他線程)
    
    static let shared = RealmManager()
    private (set) var realm: Realm
    
    private init() {
        self.realm = try! Realm()
        configRealm()
    }
    
    func configRealm() {
        self.realm.autorefresh = true
        print("realm path: \(realm.configuration.fileURL!)")
        
        let schemaVersion: UInt64 = 0
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { (migrationBlock, oldVersion) in
            if (oldVersion < schemaVersion) {}
        })
        Realm.Configuration.defaultConfiguration = config
//        Realm.asyncOpen { (realm, error) in
//            if let _ = realm {
//                print("Realm open successful.")
//            }
//            else if let error = error {
//                print("error by realm: \(error)")
//            }
//        }
    }
    
//    //帶入username "設置"對應的realm file
//    func configRealmFile(username: String) {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("\(username).realm")
//    }
//    
//    //帶入username "打開"對應的realm file
//    func openRealmFile(username: String) {
//        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: username, withExtension: "realm"), readOnly: true)
//        self.realm = try! Realm(configuration: config)
//    }
    
    //MARK: Create
    public func create(obType: Object.Type, value: Any? = nil, update: Bool = false, result: ((Object?, Error?) -> Void)? = nil) {
        do {
            try self.realm.write {
                let ob = (value == nil) ? self.realm.create(obType) : self.realm.create(obType, value: value!, update: update)
                result?(ob, nil)
            }
        } catch let error {
            result?(nil, error)
            print(RealmError.OpenFailure)
        }
    }
    
    //MARK: Insert, update 應該預設為false, 但因為primaryKey更新 所以強制帶入true
    public func add(ob: Object, update: Bool = false, result: ((Error?) -> Void)? = nil) {
        execute(clo: {
            self.realm.add(ob, update: true)
        }, result: result)
    }
    
    public func add<S: Sequence>(ob: S, update: Bool = false, result: ((Error?) -> Void)? = nil) where S.Iterator.Element: Object {
        execute(clo: {
            self.realm.add(ob, update: true)
        }, result: result)
    }
    
    //MARK: Delete
    public func delete(ob: Object, result: ((Error?) -> Void)? = nil) {
        execute(clo: {
            self.realm.delete(ob)
        }, result: result)
    }
    
    public func delete<T: Object>(type: T.Type, primaryKey: Any, result: ((Error?) -> Void)? = nil) {
        guard let specificObject = self.realm.object(ofType: type, forPrimaryKey: primaryKey) else {
            return
        }
        
        execute(clo: {
            self.realm.delete(specificObject)
        }, result: result)
        
    }
    
    public func deleteAll(result: ((Error?) -> Void)? = nil) {
        execute(clo: {
            self.realm.deleteAll()
        }, result: result)
    }
    
    public func deleteDBFile() -> Bool {
        return  autoreleasepool { () -> Bool in
            let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
            let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management")
            ]
            for URL in realmURLs {
                do {
                    try FileManager.default.removeItem(at: URL)
                    return true
                } catch {
                    print("Delete realm DB failure.")
                    return false
                }
            }
            return false
        }
    }
    
    //MARK: Update
    public func update(ob: Object, update: Bool = true, result: ((Error?) -> Void)? = nil) {
        add(ob: ob, update: update, result: result)
    }
    
    public func update<S: Sequence>(ob: S, update: Bool = true, result: ((Error?) -> Void)? = nil) where S.Iterator.Element: Object {
        add(ob: ob, update: update, result: result)
    }
    
    //根據primanryKey 更新
    public func update(type: Object.Type, value: Any? = nil, update: Bool = true, result: ((Object?, Error?) -> Void)? = nil) {
        create(obType: type, value: value, update: update, result: result)
    }
    
    //直接更新對象
    public func update(property: inout Any, value: Any) -> Bool {
        do {
            try self.realm.write {
                property = value
            }
            return true
        } catch let error {
            print("Realm update property failure: \(error.localizedDescription)")
            return false
        }
    }
    
    //MARK: Select
    public func fetch<T: Object>(type: T.Type) -> Results<T> {
        return self.realm.objects(type)
    }
    
    public func fetchAry<T: Object>(type: T.Type) -> Array<T> {
        return Array(self.realm.objects(type))
    }
    
    public func fetch<T: Object>(type: T.Type, primaryKey: Any) -> T? {
        return self.realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    
    //MARK: Execute
    private func execute(clo: (() -> Void), result: ((Error?) -> Void)? = nil) {
        do {
            try self.realm.write {
                clo()
                result?(nil)
            }
        } catch let error {
            result?(error)
            print("Realm failure: \(error.localizedDescription)")
        }
    }
}
