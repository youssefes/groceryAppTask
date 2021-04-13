//
//  RegisterOrdersViewController.swift
//  groceryApp
//
//  Created by youssef on 4/13/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class RegisterOrdersViewController:  BaseWireFrame<RegisterOrderViewModel> {

    @IBOutlet weak var Quqntityview: QuantityView!
    @IBOutlet weak var shopperTf: UITextField!
    @IBOutlet weak var regisretBtn: UIButton!
    @IBOutlet weak var loadingRegister: NVActivityIndicatorView!
    @IBOutlet weak var nameOfMarket: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    
    
    @IBOutlet weak var imageMap: UIImageView!
    @IBOutlet weak var addressTf: UITextField!
    
    var arrayShopper : [Item] = []
    
    
    var location : CLLocationCoordinate2D?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind(ViewModel: RegisterOrderViewModel) {
        
        mapViewController.selectedAddre.subscribe(onNext: {[weak self] (address) in
            guard let self = self else {return}
            self.addressTf.text = address
        }).disposed(by: disposePag)
        
        mapViewController.selectedLocation.subscribe(onNext: {[weak self] (location) in
            guard let self = self else {return}
            self.location = location
        }).disposed(by: disposePag)
        
        ViewModel.successGetShopperObservable.subscribe(onNext: { [weak self] (ShopperItems) in
            guard let self = self else {return}
            self.arrayShopper = ShopperItems
            }, onError: { (error) in
                self.presentAlertWith(msg: error.localizedDescription, {})
        }).disposed(by: disposePag)
        
        ViewModel.ssuccessRegisterOrderObservable.subscribe(onNext: { [weak self] (OrderDate) in
            guard let self = self else {return}
            self.loadingRegister.stopAnimating()
            self.loadingRegister.isHidden = true
            self.regisretBtn.isHidden = false
            
            }, onError: { (error) in
                 self.presentAlertWith(msg: error.localizedDescription, {})
        }).disposed(by: disposePag)
        
        ViewModel.getShopper()
        
        
        
    }
    func setupUi(){
        title = "New order"
        tapGestureInImage()
        
        let dataPicker = UIPickerView()
        dataPicker.dataSource = self
        dataPicker.delegate = self
        DispatchQueue.main.async {
            self.shopperTf.inputView = dataPicker
        }
        
    }
    
    @objc func DataPickerDnoeAction(){
         self.view.endEditing(true)
     }
    
    func tapGestureInImage(){
        
        imageMap.isUserInteractionEnabled = true
        let gesturemap = UITapGestureRecognizer(target: self, action: #selector(showMap))
        gesturemap.numberOfTapsRequired = 1
        imageMap.addGestureRecognizer(gesturemap)
    }
    
    @objc func showMap(){
        let mapView = coordinator.mainNavigator.viewController(for: .ShowMap)
        present(mapView, animated: true, completion: nil)
    }
    
    
    @IBAction func registerBtn(_ sender: Any) {
        
        guard  let address = addressTf.text, !address.isEmpty,let shopper = shopperTf.text,let phoneNumber = phoneTf.text, !phoneNumber.isEmpty,let name = nameOfMarket.text , !name.isEmpty , let Quqntity = Int(Quqntityview.valueLabel.text ?? "0") , Quqntity > 0 else {return}
        
        self.loadingRegister.startAnimating()
        self.loadingRegister.isHidden = false
        self.regisretBtn.isHidden = true
        
         let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone.current
        let dateString = formatter.string(from: now)
        
        let paremeters : Parameters = [
            "name" : name,
            "phoneNumber" : phoneNumber,
            "timeToDeliver" : dateString,
            "shopper" : shopper,
            "location" : [
                "type" : 1,
                "value" : [
                    "latitude": location?.latitude,
                    "longitude" : location?.latitude
                ]
                
            ]
        ]
        
        viewModel.RegisterOrder(parameters: paremeters)
        
    }

}

extension RegisterOrdersViewController : UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayShopper.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard  !arrayShopper.isEmpty else {return}
        self.shopperTf.text = arrayShopper[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayShopper[row].name
    }
    
}
