//
//  UserNethwork.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 05/02/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import Foundation
import RxSwift

public final class UserNetwork {
    
    
    private let network: Network<User>
    
    init(network: Network<User>) {
        self.network = network
    }

//    public func getUser() -> Observable<User> {
//        return network.getItem(GraphQLQuery)
//    }
}