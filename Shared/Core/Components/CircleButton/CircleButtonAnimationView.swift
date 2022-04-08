//
//  CircleButtonAnimationView.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 08.04.2022.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
            .onAppear {
                animate.toggle()
            }
        
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .frame(width: 100, height: 100)
            .foregroundColor(Color.theme.red)

    }
}

// Создаём анимацию пустого круга, который увеличивается и растворяется с целью подчеркнуть факт изменения кнопки
// Используя @Binding как триггер для воспроизведения анимации, то есть изменении bool на true в в контроллере - будет триггером для начала анимации, @Binding в инициализаторе даст возможеость использовать свои переменные в качестве триггера
// Для
