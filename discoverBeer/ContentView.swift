//
//  ContentView.swift
//  discoverBeer
//
//  Created by 박세리 on 2023/01/03.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State var beers: Beers = []
    
    var body: some View {
        VStack {
            Text("BEER LIST")
                .font(.title)
                .fontWeight(.black)
            ScrollView {
                VStack(alignment: .leading) {
                    if beers.count == 0 {
                        Text("데이터를 받아 오지 못했습니다.")
                    } else {
                        ForEach(beers) { beer in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.brown.opacity(0.4))
                                HStack {
                                    Image(systemName: "swift")
                                        .frame(width: 100, height: 100)
                                    Text("\(beer.name)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(10)
        .onAppear {
            fetchDataWithAF { (data, error) in
                guard let data = data else { return }
                beers = data
            }
        }
    }
    
    func fetchDataWithAF(completionHandler: @escaping ([BeerElement]?, Error?) -> Void) {
        // urlRequest 생성
        let apiurl = "https://api.punkapi.com/v2/beers?page=1&per_page=20"
        
        AF.request(apiurl)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [BeerElement].self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data, nil)
                    return
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil, error)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
