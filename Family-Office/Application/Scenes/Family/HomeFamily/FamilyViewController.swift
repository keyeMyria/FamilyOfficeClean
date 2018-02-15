//
//  FamilyViewController.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 14/02/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FamilyViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var v = Familystevia()
    var viewModel: FamilyViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.v
        self.title = "Familias"
        bindToView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindToView() -> Void {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let input = FamilyViewModel.Input(willAppearTrigger: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.families.drive(self.v.collectionView.rx.items(cellIdentifier: "cell", cellType: FamilyCollectionViewCell.self)) {
            tv,model,cell in
            cell.isSelected = true
            model.name.isEmpty ? cell.bind() : cell.bind(family: model)
            
        }.disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
