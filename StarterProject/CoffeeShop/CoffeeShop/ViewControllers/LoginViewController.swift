//
//  LoginViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 23.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class LoginViewController: UIViewController {
  @IBOutlet private weak var emailTextfield: UITextField!
  @IBOutlet private weak var passwordTextfield: UITextField!
  @IBOutlet private weak var logInButton: UIButton!
    
    private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let emailValid = emailTextfield
        .rx
        .text
        .orEmpty
        .map{self.validateEmail(with: $0)}
        .debug("emailValid",trimOutput: true)
        .share(replay: 1)
  }
  
  @IBAction private func logInButtonPressed() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let initialViewController = mainStoryboard.instantiateInitialViewController()!
    
    UIApplication.changeRoot(with: initialViewController)
  }
    
    //MARK: Email Validation
    private func validateEmail(with email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return predicate.evaluate(with: email)
    }
}
