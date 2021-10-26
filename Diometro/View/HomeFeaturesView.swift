//
//  HomeFeaturesView.swift
//  Diometro
//
//  Created by Vitor Krau on 18/09/20.
//

import SwiftUI

struct HomeFeaturesView: View{
    
    @State var showQuote: Bool = false
    @State var showFact: Bool = false
    @State var showActivity: Bool = false
    @State var control: Bool = false
    
    
    @State var showCamera: Bool = false
    @State var image: Image?
    @State var uiImage: UIImage?
    @State var quoteTitle: String = ""
    @State var factTitle: String = ""
    @State var activityTitle: String = ""
    @State var quote: String = "" {
        didSet {
            control.toggle()
            quoteTitle = "Quote of the day..."
        }
    }
    @State var factOfTheDay: String = "" {
        didSet {
            control.toggle()
            factTitle = "Fact of the day..."
        }
    }
    @State var activity: String = "" {
        didSet {
            control.toggle()
            activityTitle = "Are you bored?"
        }
    }
    
    var timeManager: TimeManager
    
    var body: some View {
        NavigationView {
            if self.image != nil{
                DayNightView(image: self.$image, uiImage: self.$uiImage, timeManager: timeManager)
            }
            else{
                VStack(alignment: .center){
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: ThanksView())
                        {
                            Image(systemName: "ellipsis.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(.top, 50)
                                .padding(.trailing, 20)
                        }
                    }
                    Text("DIÔMETRO")
                        .font(.system(size: 47, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    Text("Verifique se é dia ou noite")
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    Button(action: { self.showCamera = true })
                    {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 87, height: 87)
                            .foregroundColor(.white)
                    }.fullScreenCover(isPresented: self.$showCamera, content: {
                        CustomCameraView(showCamera: self.$showCamera, uiImage: self.$uiImage, timeManager: timeManager)
                            .edgesIgnoringSafeArea(.all)
                    })
                    Text("Tools")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    HStack(spacing: 16){
                        Button(action: { handleQuote() }){
                            Image(systemName: "quote.bubble.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        Button(action: { handleFact() }){
                            Image(systemName: "exclamationmark.bubble.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                        }
                        Button(action: { handBoredActivity() }){
                            Image(systemName: "figure.walk.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                        }
                    }
                    
                    if showQuote {
                        showTextView(quoteTitle, quote)
                    }
                    if showFact {
                        showTextView(factTitle, factOfTheDay)
                    }
                    if showActivity {
                        showTextView(activityTitle, activity)
                    }
        
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(setBackground())
                .ignoresSafeArea()
                .navigationBarHidden(true)
            }
        }
        .accentColor(.white)
    }
    
    fileprivate func showTextView(_ stringTitle: String, _ stringText: String) -> some View {
        return VStack {
            Text(stringTitle)
                .frame(alignment: .leading)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .modifier(FadeModifier(control: control))
                .animation(.easeIn(duration: 1))
                .padding(.top, 32)
                .padding(.bottom, 16)
            Text(stringText)
                .modifier(FadeModifier(control: control))
                .animation(.easeIn(duration: 1))
                .padding(.horizontal)
        }
    }
    
    fileprivate func setBackground() -> LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 0.247, green: 0.663, blue: 0.961, alpha: 1)), Color(UIColor(red: 0, green: 0.11, blue: 0.231, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    fileprivate func handleQuote() {
        APIRequest.shared.fetchAPI(endpoint: "https://api.quotable.io/random", model: QuotableModel.self, completion: {
                result in
            switch result {
            case .success(let result):
                quote = result.content
                showFact = false
                showActivity = false
                withAnimation(.easeIn(duration: 1)){
                    showQuote = true
                }
            case .failure(_):
                return
            }
        })
    }
    
    fileprivate func handleFact() {
        APIRequest.shared.fetchAPI(endpoint: "https://uselessfacts.jsph.pl/random.json?language=en", model: FactModel.self, completion: {
                result in
            switch result {
            case .success(let result):
                factOfTheDay = result.text
                showQuote = false
                showActivity = false
                withAnimation(.easeIn(duration: 1)){
                    showFact = true
                }
            case .failure(_):
                return
            }
        })
    }
    
    fileprivate func handBoredActivity() {
        APIRequest.shared.fetchAPI(endpoint: "https://www.boredapi.com/api/activity?participants=1", model: BoredModel.self, completion: {
                result in
            switch result {
            case .success(let result):
                activity = result.activity
                showQuote = false
                showFact = false
                withAnimation(.easeIn(duration: 1)){
                    showActivity = true
                }
            case .failure(_):
                return
            }
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var timeManager: TimeManager = TimeManager()
    static var previews: some View {
        HomeFeaturesView(timeManager: timeManager)
    }
}
