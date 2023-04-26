//
//  LottieView.swift
//  Gurenter-Tenant (iOS)
//
//  Created by Keijaoh Campbell on 3/20/23.
//

import SwiftUI
import Lottie

enum LottieAnimType: String {
    case empty_face = "empty-face"
    case address_not_found = "address_not_found"
    case empty_people_list = "empty_people_list"
    case no_pets_found = "no_pets_found"
    case wallet_of_money_and_credit_card = "wallet_of_money_and_credit_card"
    case money_vault = "money_vault"
}

struct LottieView: UIViewRepresentable {
    
    var animType: LottieAnimType
    let animationView = LottieAnimationView()
    //reference to Lottie depreciation of Animation.named and AnimationView
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let view = UIView()
        let animation = LottieAnimation.named(animType.rawValue)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(animType: .empty_face)
    }
}

