//
//  ThanksView.swift
//  Diometro
//
//  Created by Vitor Krau on 26/08/21.
//

import SwiftUI

struct ThanksView: View {
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Text("Agradecimentos")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 64)
                Spacer()
                PersonCard(image: "bi", title: "Bianca Pirmez", role: "App Store Designer", instagram: "bianca_pirmez", behanceLink: "biancapirmez")
                PersonCard(image: "soares", title: "Matheus Soares", role: "A Mente Brilhante", behance: false, instagram: "matheussssssssssss")
                PersonCard(image: "", title: "Mohamed Lucas", role: "App Designer", instagram: "mohamedsuspeito", behanceLink: "mohamedlucas")
                Spacer()
                Text("Feito por Vitor Krau")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                HStack {
                    Button(action: { UIApplication.shared.open(URL(string: "https://instagram.com/vitorkrau")!) }){
                        Image("instagram logo")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    Button(action: {UIApplication.shared.open(URL(string: "https://github.com/vitorkrau/diometro")!)}){
                        Image("github logo")
                            .resizable()
                            .frame(width: 28, height: 28, alignment: .center)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(setBackground())
            .edgesIgnoringSafeArea(.all)
        }

    }
    
    fileprivate func setBackground() -> LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 0.247, green: 0.663, blue: 0.961, alpha: 1)), Color(UIColor(red: 0, green: 0.11, blue: 0.231, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct ThanksView_Previews: PreviewProvider {
    static var previews: some View {
        ThanksView()
    }
}


struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder().foregroundColor(.white))
    }
    
}

struct PersonCard: View {
    
    var instagramURL: String = "https://instagram.com/"
    var behanceURL: String = "https://behance.net/"
    
    var image: String
    var title: String
    var role: String
    var behance: Bool = true
    var instagram: String?
    var behanceLink: String?
    
    var body: some View {
        HStack(alignment: .center) {
            Image(image)
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.horizontal, 10)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top)
                Text(role)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.8))
                HStack {
                    Button(action: {
                        UIApplication.shared.open(URL(string: instagramURL + instagram!)!)
                    }){
                        Image("instagram logo")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    if(behance){
                        Button(action: {
                            UIApplication.shared.open(URL(string: behanceURL + behanceLink!)!)
                        }){
                            Image("behance logo")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                    }
                }.padding(.bottom)
            }
            .padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)
        .background(Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.1))
        .modifier(CardModifier())
        .padding(.all, 10)
        
    }
}
