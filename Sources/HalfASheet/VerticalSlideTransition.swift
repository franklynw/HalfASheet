//
//  VerticalSlideModifier.swift
//
//  Created by Franklyn Weber on 28/01/2021.
//  Copyright © 2021 Franklyn. All rights reserved.
//

import SwiftUI


fileprivate struct VerticalSlideModifier: ViewModifier {
    
    let offset: CGFloat
    
    @available(macOS 10.15.0, *)
    func body(content: Content) -> some View {
        
        content
            .offset(CGSize(width: 0, height: offset))
    }
}


@available(macOS 10.15, *)
extension AnyTransition {
    
    static func verticalSlide(_ offset: CGFloat? = nil) -> AnyTransition {
        
        .modifier(
            active: VerticalSlideModifier(offset: offset ?? UIScreen.main.bounds.height),
            identity: VerticalSlideModifier(offset: 0)
        )
    }
}
