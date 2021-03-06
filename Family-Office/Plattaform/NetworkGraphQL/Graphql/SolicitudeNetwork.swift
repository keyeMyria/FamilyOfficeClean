//
//  SolicitudeNetwork.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 23/02/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import Foundation
import RxSwift

public final class ApplicationsNetwork {
    private let network: Network<ApplicationFamily>

    init(network: Network<ApplicationFamily>) {
        self.network = network
    }

    func createFamilyApplication(_ solicitude: ApplicationFamily) -> Observable<ApplicationFamily> {
        return network.postItem(FamilyApplicationMutation(userId: solicitude.user.uid, familyId: solicitude.family.uid))
    }
    
    func allFamilyApplications() -> Observable<[ApplicationFamily]> {
        return network.getItems(FamilyApplicationsQuery())
    }
    func approve(aid: String) -> Observable<ApplicationFamily> {
        return network.postItem(AcceptFamilyApplicationMutation(id: aid))
    }

}

public final class ApplicationAssistantNetwork {
    private let network: Network<ApplicationAssistant>
    
    init(network: Network<ApplicationAssistant>) {
        self.network = network
    }
    func createAssitantApplication(_ aid: String) -> Observable<ApplicationAssistant> {
        return network.postItem(AssitantApplicationsMutation(aid: aid))
    }
    func getApplications() -> Observable<[ApplicationAssistant]>{
        return network.getItems(AllApplicationsAssistantsQuery())
    }
}


