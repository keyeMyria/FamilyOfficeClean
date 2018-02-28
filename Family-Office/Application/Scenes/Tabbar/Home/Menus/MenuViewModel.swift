//
//  MenuViewModel.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 09/02/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

final class MenuViewModel: ViewModelType {
    private var familyUseCase: FamilyUseCase!
    private var navigator: MenuNavigator!
    private var families = [Family]()
    init(service: FamilyUseCase, navigator: MenuNavigator = MenuNavigator()) {
        self.familyUseCase = service
        self.navigator = navigator
    }

    func transform(input: MenuViewModel.Input) -> MenuViewModel.Output {

        let families = input.trigger.flatMapLatest {
             return self.getMyFamilies(self.familyUseCase)
            }.do(onNext: {self.families = $0})
        let logout = input.triggerLogout
            .do(onNext: {
                self.logout()
                self.navigator.logout()
            })
        let selected = input.triggerSelected.flatMapLatest { (indexpath) in
            return self.familyUseCase
                .changeFamilyActive(family: self.families[indexpath.row])
                .asDriverOnErrorJustComplete()
        }
        return Output(families: families, selected: selected, logout: logout)
    }

}
extension MenuViewModel {
    struct Input {
        let trigger: Driver<Void>
        let triggerSelected: Driver<IndexPath>
        let triggerLogout: Driver<Void>
    }
    struct Output {
        let families: Driver<[Family]>
        let selected: Driver<Void>
        let logout: Driver<Void>
    }
}
