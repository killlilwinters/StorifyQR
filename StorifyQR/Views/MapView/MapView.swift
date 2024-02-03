//
//  MapView.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.01.2024.
//
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-animate-changes-in-binding-values
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Bindable var viewModel = MapViewModel.shared
    
    var body: some View {
        VStack {
            Text("Location:")
                .font(.system(.headline))
                .padding(.horizontal)
            if viewModel.isIncludingLocation {
                VStack {
                    Map(position: $viewModel.mapRegionPosition) {
                        Marker("Item's location", coordinate: viewModel.rawLocation)
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .allowsHitTesting(false)
                    LocationNameBar(locationName: viewModel.locationName)
                        .onAppear(perform: viewModel.getLocationName)
                }
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            Toggle("Include location?", isOn: $viewModel.isIncludingLocation.animation())
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
