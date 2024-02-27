//
//  MapView.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.01.2024.
//
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-animate-changes-in-binding-values
//
// https://www.hackingwithswift.com/books/ios-swiftui/adding-user-locations-to-a-map
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
                    ZStack(alignment: .bottomTrailing) {
                        MapReader { proxy in
                            Map(position: $viewModel.mapRegionPosition) {
                                Marker("Item's location", coordinate: viewModel.finalLocation)
                            }
                            .onTapGesture { position in
                                if let coordinate = proxy.convert(position, from: .local) {
                                    viewModel.userCustomLocation = coordinate
                                }
                            }
                        }
                        if viewModel.userCustomLocation != nil {
                            Button {
                                viewModel.resetLocation()
                            } label: {
                                Image(systemName: "location.fill.viewfinder")
                                    .padding(10)
                                    .tint(.primary)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .tint(.contentPad)
                                    )
                            }
                            .padding()
                        }
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    LocationNameBar(locationName: viewModel.locationName)
                        .onAppear(perform: viewModel.getLocationName)
                }
                .optionalTrnsition(transition: .asymmetric(insertion: .scale, removal: .opacity))
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
