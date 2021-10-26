//
//  DayNightView.swift
//  Diometro
//
//  Created by Vitor Krau on 18/09/20.
//

import SwiftUI


struct DayNightView: View {
    
    @Binding var image: Image?
    @Binding var uiImage: UIImage?
    @ObservedObject var im: ImageClassifier = ImageClassifier()
    var timeManager: TimeManager
    
    var body: some View {
        ZStack{
            if self.image != nil{
                self.image!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    setOverlay(timeOfTheDay: timeManager.getTimeOfTheDay())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, 100)
                    Spacer()
                    Button(action: { self.image = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 5)
                            .padding(.bottom, 36)
                    }
                }
                .ignoresSafeArea()
            }
            
            if im.label != ""{
                Text(im.label)
            }
        }.onAppear{
            im.classify(image: self.uiImage!)
        }
        
    }
    
    fileprivate func setOverlay(timeOfTheDay: String) -> some View{
        return
            Text(timeOfTheDay)
            .font(.system(size: 70, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .shadow(color: .gray, radius: 5)
        
    }
}
