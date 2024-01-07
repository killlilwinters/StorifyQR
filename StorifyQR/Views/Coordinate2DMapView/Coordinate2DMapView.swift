//
//  Coordinate2DMapView.swift
//  StorifyQR
//
//  Created by Maks Winters on 07.01.2024.
//

import SwiftUI
import MapKit

struct Coordinate2DMapView: View {
    
    @Bindable var viewModel: Coordinate2DMapViewModel
    
    var body: some View {
        VStack {
            Text("Registered location:")
                .font(.system(.headline))
                .padding(.horizontal)
            Map(position: $viewModel.mapRegionPosition) {
                Marker("Item's location", coordinate: viewModel.rawLocation)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .allowsHitTesting(false)
        }
        .modifier(ContentPad())
        .padding(.horizontal)
    }
    
    init(coordinate2D: Coordinate2D) {
        self.viewModel = Coordinate2DMapViewModel(coordinate2D: coordinate2D)
    }
    
}

#Preview {
    Coordinate2DMapView(coordinate2D: Coordinate2D(latitude: 8.000, longitude: 10.000))
}
