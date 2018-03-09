//
//  RMChat.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 07/03/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//
import Foundation
import RealmSwift

@objcMembers
final class RMChat: Object {
    
    dynamic var family: RMFamily?
    
    dynamic var name = ""
    
    dynamic var photo: RMAttachment?
    
    dynamic var uid: String = ""
    
    dynamic var lastMessage: RMMessage?
    
    dynamic var members = List<RMChatMembership>()
    
    dynamic var messages = List<RMMessage>()
    
    override class func primaryKey() -> String {
        return "uid"
    }
}

extension RMChat: DomainConvertibleType {
    func asDomain() -> Chat {
        return Chat(family: family?.asDomain(), group: ChatGroup(name: name, photo: photo?.asDomain()), uid: uid, lastMessage: lastMessage?.asDomain(), members: Array(members.map({$0.asDomain()})), messages: Array(messages.map({$0.asDomain()})))
    }
}

extension Chat: RealmRepresentable {
    
    typealias RealmType = RMChat

    func asRealm() -> RMChat {
        return RMChat.build({ (obj) in
            obj.family = family?.asRealm()
            obj.uid = uid
            obj.name = group?.name ?? ""
            obj.photo = group?.photo?.asRealm()
            obj.lastMessage = lastMessage?.asRealm()
            obj.messages.append(objectsIn: messages.map({$0.asRealm()}))
            obj.members.append(objectsIn: members.map({$0.asRealm()}))
        })
    }
   
}

