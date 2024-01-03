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
        Map(position: $viewModel.mapRegionPosition) {
            Marker("Item's location", coordinate: viewModel.rawLocation)
        }
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }
}

#Preview {
    MapView()
}
