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
            VStack(alignment: .leading) {
                if beers.count == 0 {
                    Text("데이터를 받아 오지 못했습니다.")
                } else {
                    ForEach(beers) { beer in
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.brown.opacity(0.4))
                            Text("\(beer.name)")
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

            
//            fetchData { (data, error) in
//                guard let data = data else { return }
//                let decoder = JSONDecoder()
//                let result = try? decoder.decode([BeerElement].self, from: data)
//                beers = result ?? []
//            }
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

//            .response { response in
//
//                switch response.result {
//                case .success(let data):
//                    completionHandler(data, nil)
//                    return
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    completionHandler(nil, error)
//                }
    }
    
    func fetchData(completionHandler: @escaping (Data?, Error?) -> Void) {
        // urlRequest 생성
        let apiurl = "https://api.punkapi.com/v2/beers?page=1&per_page=10"
//        let apiurl = "https://api.punkapi"
        guard let url = URL(string: apiurl) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // 데이터 통신 코드
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("😗error form URLSession : \(error)")
                print("😗response : \(response)")
                print("😗data : \(data)")
                completionHandler(nil, error)
            }
            
            if let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 {
                print("httpResponse: \(httpResponse.statusCode)")
                print("😗error form URLSession : \(error)")
                print("😗response : \(response)")
                print("😗data : \(data)")
                DispatchQueue.main.async {
                    completionHandler(data, nil)
                }
            } else {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
