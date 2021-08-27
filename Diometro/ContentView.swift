//
//  ContentView.swift
//  Diometro
//
//  Created by Vitor Krau on 18/09/20.
//

import SwiftUI

struct ContentView: View{
    
    @State var showCamera: Bool = false
    @State var image: Image?
    @State var uiImage: UIImage?
    
    var body: some View {
        NavigationView {
            if self.image != nil{
                DayNightView(image: self.$image, uiImage: self.$uiImage)
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
                    
                    Spacer()
                    Text("DIÔMETRO")
                        .font(.system(size: 47, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    Text("Verifique se é dia ou noite")
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 87)
                    
                    Button(action: { self.showCamera = true })
                    {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 87, height: 87)
                            .foregroundColor(.white)
                    }.fullScreenCover(isPresented: self.$showCamera, content: {
                        CustomCameraView(showCamera: self.$showCamera, uiImage: self.$uiImage).edgesIgnoringSafeArea(.all)
                    })
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
    
    fileprivate func setBackground() -> LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 0.247, green: 0.663, blue: 0.961, alpha: 1)), Color(UIColor(red: 0, green: 0.11, blue: 0.231, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
