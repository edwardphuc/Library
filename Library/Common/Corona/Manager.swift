

import Foundation
import Alamofire

class ManagerNetworking {
    private var URLstring =  "https://coronavirus-19-api.herokuapp.com/countries"
    static var instance = ManagerNetworking()
    //fetch all data
    func fetchData(completion: ([CountriesInfo]) -> Void) {
        var listCounties : [CountriesInfo] = []
        AF.request(URLstring).responseJSON { (results) in
            do {
                listCounties = try JSONDecoder().decode([CountriesInfo].self, from: results.data!)
            }
            catch {
                print(error)
            }
        }
        completion(listCounties)
    }
    //
    func fectdatawithcoutry(urlcountry: String, Completion: @escaping (CountriesInfo)->Void) {
        let url: String = API.instance.URL(path: urlcountry)
        AF.request(url).responseJSON { (data) in
            switch data.result {
            case .success:
                do {
                    let country = try JSONDecoder().decode(CountriesInfo.self, from: data.data!)
                    Completion(country)
                }
                catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            
        }
    }
    }
}
