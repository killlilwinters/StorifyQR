//
//  MapView.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.01.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Bindable var viewModel = MapViewModel()
    
    var body: some View {
        VStack {
            Text("Location:")
                .font(.system(.headline))
                .padding(.horizontal)
            if viewModel.isIncludingLocation {
                Map(position: $viewModel.mapRegionPosition) {
                    Marker("Item's location", coordinate: viewModel.rawLocation)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .allowsHitTesting(false)
            }
            Toggle("Include location?", isOn: $viewModel.isIncludingLocation)
                .padding(.horizontal, 5)
                .disabled(!viewModel.isLocationAvailable)
                .onTapGesture {
                    viewModel.showAlerts = true
                    viewModel.checkIfLocationServicesIsEnabled()
                }
        }
        .modifier(ContentPad())
        .padding(.horizontal)
        .onAppear {
            viewModel.showAlerts = false
            viewModel.checkIfLocationServicesIsEnabled()
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK") { }
        }
    }
}

#Preview {
    MapView()
}
