//
//  AsyncView.swift
//  dialcrown_text Watch App
//
//  Created by shiranekaoru on 2024/04/04.
//

import Foundation
import SwiftUI


struct AsyncView: View{
    @State var opacity = 1.0
    @State var isTapped = false
    
    var body: some View{
        
        VStack{
            Text("Hello")
                .font(.system(size: 65))
                .fontWeight(.bold)
                .opacity(opacity)
            
            Slider(value: $opacity, in: 0...1){
                Text("Opacity")
            }
            .padding()
            
            Button{
                sleep(5)
            } label: {
                Text("Count")
                    .frame(maxWidth: 180, maxHeight: 66)
            }
            .buttonStyle(.bordered)
            
            Button{
                Task{
                    
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                    isTapped.toggle()
                }
            }label: {
                Text("Async count")
                    .frame(maxWidth: 180, maxHeight: 66)
            }
            .buttonStyle(.bordered)
        }
        
    }
}
