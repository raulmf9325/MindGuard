//
//  HomeView.swift
//  ScreenSentry
//
//  Created by Raul Mena on 5/5/24.
//

import AppUI
import ComposableArchitecture
import SwiftUI
import ScreenTimeAPI

public struct HomeView: View {
    @Perception.Bindable var store: StoreOf<Home>
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                AppTheme.Colors.accentColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        if store.screenTimeAccess == .denied {
                            PermissionDeniedView(onButtonTapped: requestScreenTimeAccess)
                            Spacer()
                        } else {
                            BlockContentView()
                        }
                    }
                    .padding(10)
                }
            }
        }
        .onAppear {
            store.send(.onHomeViewAppeared)
        }
    }
    
    func requestScreenTimeAccess() {
        store.send(.requestScreenTimeApiAccess)
    }
}


#Preview {
    HomeView(store: Store(initialState: Home.State()) {
        Home()
    } withDependencies: {
        $0.screenTimeApi.requestAccess = { @Sendable in
            return .approved
        }
    } )
}

