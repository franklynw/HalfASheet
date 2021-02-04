//
//  If.swift
//
//  Created by Franklyn Weber on 15/01/2021.
//

import SwiftUI


struct If: View {
    
    private let viewProvider: () -> AnyView
    
    
    init<V: View>(_ isTrue: Binding<Bool>, @ViewBuilder _ viewProvider: @escaping () -> V) {
        self.viewProvider = {
            isTrue.wrappedValue ? AnyView(viewProvider()) : AnyView(EmptyView())
        }
    }
    
    init<V: View, O: View>(_ isTrue: Binding<Bool>, @ViewBuilder _ viewProvider: @escaping () -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            isTrue.wrappedValue ? AnyView(viewProvider()) : AnyView(otherViewProvider())
        }
    }
    
    init<V: View>(_ condition: @autoclosure @escaping () -> Bool, @ViewBuilder _ viewProvider: @escaping () -> V) {
        self.viewProvider = {
            condition() ? AnyView(viewProvider()) : AnyView(EmptyView())
        }
    }
    
    init<V: View, O: View>(_ condition: @autoclosure @escaping () -> Bool, @ViewBuilder _ viewProvider: @escaping () -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            condition() ? AnyView(viewProvider()) : AnyView(otherViewProvider())
        }
    }
    
    var body: some View {
        return viewProvider()
    }
}


struct IfLet: View {
    
    private let viewProvider: () -> AnyView
    
    
    init<T, V: View>(_ item: Binding<T?>, @ViewBuilder _ viewProvider: @escaping (T) -> V) {
        self.viewProvider = {
            AnyView(item.wrappedValue.map {
                viewProvider($0)
            })
        }
    }
    
    init<T, V: View, O: View>(_ item: Binding<T?>, @ViewBuilder _ viewProvider: @escaping (T) -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            if let item = item.wrappedValue {
                return AnyView(viewProvider(item))
            } else {
                return AnyView(otherViewProvider())
            }
        }
    }
    
    init<T, V: View>(_ item: T?, @ViewBuilder _ viewProvider: @escaping (T) -> V) {
        self.viewProvider = {
            AnyView(item.map {
                viewProvider($0)
            })
        }
    }
    
    init<T, V: View, O: View>(_ item: T?, @ViewBuilder _ viewProvider: @escaping (T) -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            if let item = item {
                return AnyView(viewProvider(item))
            } else {
                return AnyView(otherViewProvider())
            }
        }
    }
    
    var body: some View {
        return viewProvider()
    }
}
