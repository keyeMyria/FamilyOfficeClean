//
//  Family.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 29/01/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import Foundation

public struct Family : Codable {
    
    public var uid: String = ""
    public var name: String = ""
    public var photo: Photo? = nil
    public var admin: String? = ""
    public var members = [User]()
    public var isSelected = false
    public init(name: String,
                admin: String,
                members: [User],
                uid: String) {
        self.admin = admin
        self.members = members
        self.photo = nil
        self.name = name
        self.uid = uid
    }
    public init(name: String) {
        self.admin = ""
        self.members = []
        self.photo = nil
        self.name = name
        self.uid = ""
    }
    public init(from decoder: Decoder) throws
    {
        
        if  let values = try? decoder.container(keyedBy: CodingKeys.self) {
            
            name = try values.decode(String.self, forKey: .name)
            
            uid = try values.decode(String.self, forKey: .uid)
            
            photo = try! values.decodeIfPresent(Photo.self, forKey: .photo)
            members = try values.decodeIfPresent([[String:User]].self, forKey: .members)?.flatMap({$0.values.filter({
            !$0.uid.isEmpty})}) ?? []
        }
        
        
//        members = try values.decode()
    }
    
}

extension Family: Equatable {
    public static func == (lhs: Family, rhs: Family) -> Bool {
        return lhs.name == rhs.name &&
            lhs.photo == rhs.photo &&
            lhs.admin == rhs.admin &&
            lhs.members == rhs.members
    }
}
