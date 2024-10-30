//
//  ViewController.swift
//  ConsolidationVI
//
//  Created by Eren Elçi on 30.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController , UITableViewDelegate  {
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var countryList = [Datum]()
    var countryVM = CountryViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.title = "Country Population Info MVVM && RXSwift"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setupBindigs()
        countryVM.requestData()
        tiklandi()
    }
    
    private func setupBindigs(){
        countryVM.loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        countryVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        
        countryVM
            .country
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: CountryTableViewCell.self)) { row,item,cell in
                cell.item = item
                
            }.disposed(by: disposeBag)
        
    }
    func tiklandi() {
        tableView.rx.modelSelected(Datum.self)
            .subscribe(onNext: { [weak self] selectedCountry in
                // Detay sayfasına geçiş
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as?  DetailCountryViewController {
                    detailVC.selectedCountry = selectedCountry // Veriyi geçir
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
