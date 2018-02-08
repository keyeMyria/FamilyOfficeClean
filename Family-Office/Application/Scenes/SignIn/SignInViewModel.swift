//
//  SignInViewModel.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 29/01/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class SignInviewModel: ViewModelType {
    private let authUseCase : AuthUseCase
    private let navigator: DefaultAuthNavigator
    
    init(useCase: AuthUseCase, navigator: DefaultAuthNavigator) {
        self.authUseCase = useCase
        self.navigator = navigator
    }
    func transform(input: SignInviewModel.Input) -> SignInviewModel.Output {
        let errorTracker = ErrorTracker()
        let emailAndPassword = Driver.combineLatest(input.email, input.password).map({ (e, p) -> (String,String) in
            let email = UserDefaults().value(forKey: "email") as? String ?? e
            let pass =  UserDefaults().value(forKey: "password") as? String ?? p
            return ( email , pass )
        })
        let activityIndicator = ActivityIndicator()
        let canLogin = Driver.combineLatest(emailAndPassword, activityIndicator.asDriver()) {
            return !$0.0.isEmpty && !$0.1.isEmpty && !$1
        }
        
        let login = input.loginTrigger.withLatestFrom(emailAndPassword).flatMapLatest({
             [unowned self] in
            
            return self.authUseCase
                .signIn(email: $0.0, password: $0.1)
                .trackError(errorTracker)
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        })
        .do(onNext: navigator.toPreHome)
        
     
        
        let signUp = input.signUpTrigger
            .do(onNext: navigator.toSignUp)
        
        return Output(dismiss: login, loginEnabled: canLogin, signUp: signUp, emailpass: emailAndPassword, error: errorTracker.asDriver())
    }
}
extension SignInviewModel {
    struct Input {
        let signUpTrigger: Driver<Void>
        let loginTrigger: Driver<Void>
        var email: Driver<String>
        var password: Driver<String>
    }
    struct Output {
        let dismiss: Driver<User>
        let loginEnabled: Driver<Bool>
        let signUp: Driver<Void>
        let emailpass: Driver<(String,String)>
        let error: Driver<Error>
    }
}
