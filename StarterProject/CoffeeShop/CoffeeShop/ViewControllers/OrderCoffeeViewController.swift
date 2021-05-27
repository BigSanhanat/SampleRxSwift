//
//  OrderCoffeeViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 24.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderCoffeeViewController: BaseViewController {
  @IBOutlet private weak var coffeeIconImageView: UIImageView!
  @IBOutlet private weak var coffeeNameLabel: UILabel!
  @IBOutlet private weak var coffeePriceLabel: UILabel!
  @IBOutlet private weak var orderCountLabel: UILabel!
  @IBOutlet private weak var removeButton: UIButton!
  @IBOutlet private weak var addButton: UIButton!
  @IBOutlet private weak var totalPrice: UILabel!
  @IBOutlet private weak var addToCartButton: UIButton!
  
    private let disposeBag = DisposeBag()
    
  var coffee: Coffee!
    var totalOrder: BehaviorRelay<Int> = .init(value: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    totalOrder.subscribe(onNext: {[weak self] totalOrderCount in
        self?.orderCountLabel.text = "\(totalOrderCount)"
        self?.totalPrice.text = CurrencyFormatter.turkishLirasFormatter.string(from: Float(totalOrderCount) * (self?.coffee.price ?? 0))
    })
    .disposed(by: disposeBag)
    
    populateUI()
  }
  
  private func populateUI() {
    guard let coffee = coffee else { return }
    
    coffeeNameLabel.text = coffee.name
    coffeeIconImageView.image = UIImage(named: coffee.icon)
    coffeePriceLabel.text = CurrencyFormatter.turkishLirasFormatter.string(from: coffee.price)
//    totalOrder = 0
  }
  
  @IBAction private func addButtonPressed() {
    var order = totalOrder.value
    order += 1
    
    totalOrder.accept(order)
  }
  
  @IBAction private func removeButtonPressed() {
    guard totalOrder.value > 0 else { return }
    
    var order = totalOrder.value
    order -= 1
    
    totalOrder.accept(order)
  }
  
  @IBAction private func addToCartButtonPressed() {
    guard let coffee = coffee else { return }
    
    ShoppingCart.shared.addCoffee(coffee, withCount: totalOrder.value)
    
    navigationController?.popViewController(animated: true)
  }
}
