##  MVVM && RXSwift Country Population Info App 
<img src="https://github.com/user-attachments/assets/9cf3cfc9-98de-4514-a595-ce9819c5d4ab" alt="Ekran-Kaydı-2024-10-18" style="width:240px; height:526px;" />

<details>
    <summary><h2>Uygulma Amacı</h2></summary>
  MVVM (Model-View-ViewModel) mimarisi ve RxSwift kütüphanesi kullanarak yapılandırılmıştir.Projen, dünya genelindeki şehirlerin nüfus bilgilerini çekmek ve kullanıcıya bu bilgileri sunmak amacıyla geliştirilmiştir. Uygulama, kullanıcıların belirli bir şehir veya ülkenin nüfus verilerini kolay bir şekilde görmesini sağlar. Bu amaç doğrultusunda, kullanıcı arayüzü ile veri modeli arasındaki etkileşimi yönetmek için MVVM mimarisi kullanılmaktadır. RxSwift, asenkron veri akışlarını ve olayları yönetmek için entegre edilmiştir.
  </details> 
  
  <details>
    <summary><h2>MVVM Mimarisi</h2></summary>
    Model: Uygulamanın verilerini ve iş mantığını temsil eder. Projende Country, Datum, ve PopulationCount gibi yapılar bu kısımda yer alır. Bu yapılar, API'den gelen JSON verilerini temsil eder ve Codable protokolü sayesinde JSON'dan nesnelere dönüşüm yapılmasını sağlar.
    View: Kullanıcı arayüzünü temsil eder. Bu kısımda kullanıcıya görsel olarak bilgi sunulur. Arayüz, ViewModel ile iletişim kurarak kullanıcıya güncel verileri gösterebilir.
    ViewModel: Model ve View arasında bir köprü görevi görür. CountryViewModel sınıfında, API'den veri çekmek ve bu verileri View'e sunmak için gerekli olan iş mantığı ve durum yönetimi bulunur. Bu sınıf, RxSwift ile birlikte PublishSubject kullanarak veri akışını yönetir.
  </details> 

  <details>
    <summary><h2>Model</h2></summary>
    Uygulamanın verilerini ve iş mantığını temsil eder.

    
    ```
    import Foundation

    struct Country: Codable {
    let error: Bool
    let msg: String
    let data: [Datum]
    }

    struct Datum: Codable {
    let city: String
    let country: String
    let populationCounts: [PopulationCount]
     }

    struct PopulationCount: Codable {
    let year: String
    let value: String?
    let sex: Sex?
    let reliability: Reliability?
    }

    enum Reliability: String, Codable {
    case cityInner = "city inner"
    case finalFigureComplete = "Final figure, complete"
    case otherEstimate = "Other estimate"
    case provisionalFigure = "Provisional figure"
    }

    enum Sex: String, Codable {
    case bothSexes = "Both Sexes"
    case usually = "usually"
    }



    ```
  </details> 




<details>
    <summary><h2>Service</h2></summary>
    API çağrısını yöneten sınıf.

    
    ```
    import Foundation

    enum CountryError: Error {
    case serverError
    case parsingError
    }

    class Webservice {
    func downloadCountry(url: URL, completion: @escaping (Result<[Datum], CountryError>) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(CountryError.serverError))
            } else if let data = data {
                let country = try? JSONDecoder().decode(Country.self, from: data)
                if let country = country {
                    completion(.success(country.data))
                } else {
                    completion(.failure(CountryError.parsingError))
                }
            }
        }.resume()
    }
    }




    ```
  </details>

  <details>
    <summary><h2>ViewModel</h2></summary>
   Model ve View arasında köprü görevi gören sınıf.

    
    ```
    import Foundation
    import RxSwift
    import RxCocoa

    class CountryViewModel {
    let country: PublishSubject<[Datum]> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()

    func requestData() {
        self.loading.onNext(true)
        let url = URL(string: "https://countriesnow.space/api/v0.1/countries/population/cities")!
        Webservice().downloadCountry(url: url) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let country):
                self.country.onNext(country)
            case .failure(let error):
                switch error {
                case .parsingError:
                    self.error.onNext("Parsing Error")
                case .serverError:
                    self.error.onNext("Server Error")
                }
            }
        }
    }
    }




    ```
  </details>
  <details>
    <summary><h2>View</h2></summary>
    ViewController, kullanıcı arayüzünün yönetiminden sorumludur. RxSwift kullanarak asenkron veri akışlarını yönetir ve kullanıcı etkileşimlerine yanıt verir. MVVM mimarisi sayesinde model ve görünüm arasındaki etkileşimleri kolayca yönetir, bu da uygulamanın bakımını ve genişletilmesini kolaylaştırır. Uygulama, kullanıcıların dünya genelindeki şehirlerin nüfus bilgilerine erişimini sağlar.
    viewDidLoad: Görünüm yüklendiğinde çağrılır. Arka plan rengini, başlığı ve tablo delegesini ayarlar.
    setupBindings: ViewModel ile görsel bileşenler arasındaki veri bağlamalarını kurar.
    countryVM.requestData(): Verileri almak için ViewModel'den istek yapar.
    tiklandi(): Kullanıcı seçimlerini işlemek için abone olur.
    Loading Binding: loading özelliği, indicatorView'in animasyon durumuna bağlanır. Veriler yüklenirken gösterilir.
    Error Handling: error özelliği için bir abone oluşturulur; hata durumunda konsola hata mesajı yazdırılır.
    Country Binding: country özelliği, tableView'e bağlanır. Alınan veriler, her bir hücre için CountryTableViewCell'de gösterilir.
    Model Seçimi: Kullanıcı bir hücreyi seçtiğinde modelSelected ile tetiklenir. Seçilen ülke verisi detay sayfasına geçiş yapmak için kullanılır.
    Detay Sayfası: Yeni bir DetailCountryViewController örneği oluşturulur ve seçilen ülke verisi bu sayfaya aktarılır.

    
    ```
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    self.title = "Country Population Info MVVM && RXSwift"
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    setupBindings()
    countryVM.requestData()
    tiklandi()
    }

    private func setupBindings() {
    countryVM.loading
        .bind(to: self.indicatorView.rx.isAnimating)
        .disposed(by: disposeBag)
    
    countryVM.error
        .observe(on: MainScheduler.asyncInstance)
        .subscribe { errorString in
            print(errorString)
        }
        .disposed(by: disposeBag)
    
    countryVM.country
        .observe(on: MainScheduler.asyncInstance)
        .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: CountryTableViewCell.self)) { row, item, cell in
            cell.item = item
        }.disposed(by: disposeBag)
     }


     func tiklandi() {
    tableView.rx.modelSelected(Datum.self)
        .subscribe(onNext: { [weak self] selectedCountry in
            // Detay sayfasına geçiş
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailCountryViewController {
                detailVC.selectedCountry = selectedCountry // Veriyi geçir
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
        })
        .disposed(by: disposeBag)
    }

    ```
  </details>
  
<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;"> MVVM ve RxSwift yapısı ile verilerin yüklenmesi</h4>
            <img src="https://github.com/user-attachments/assets/3a4b4685-4373-4be8-af3d-aeae8985c06a" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Veriler yüklendikten sonra</h4>
            <img src="https://github.com/user-attachments/assets/fe564028-ad42-4d9a-ae6a-83cac68de0cb" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Detail Sayfasi</h4>
            <img src="https://github.com/user-attachments/assets/c828403c-1928-42c6-bfd9-4008ac18e253" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
