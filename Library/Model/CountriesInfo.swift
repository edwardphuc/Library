
import Foundation
import RealmSwift
//{"country":"World",
//"cases":24061215,
//"todayCases":10045,
//"deaths":823513,
//"todayDeaths":785,
//"recovered":16608597,
//"active":6629105,
//"critical":61792,
//"casesPerOneMillion":3087,
//"deathsPerOneMillion":105,
//"totalTests":0,
//"testsPerOneMillion":0}

struct CountriesInfo : Codable {
    var country: String?
    var cases: Int?
    var todayCases: Int?
    var deaths : Int?
    var todayDeaths : Int?
    var recovered : Int?
    var active : Int?
    var critical : Int?
    var casesPerOneMillion : Int?
    var deathsPerOneMillion :Int?
    var totalTests : Int?
    var testsPerOneMillion : Int?
}

