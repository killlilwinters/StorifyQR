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
    
    @Bindable private var viewModel: MapViewModel
    
    var isIncludingLocation: Bool {
        viewModel.isIncludingLocation
    }
    var latestLocation: Coordinate2D? {
        viewModel.getCurrentLocation()
    }
    
    func includeLocation() {
        viewModel.isIncludingLocation.toggle()
    }
    
    var body: some View {
        LazyVStack {
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
                        if viewModel.userCustomLocation != nil || viewModel.editingLocation != nil {
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
                    print("Tapped")
                    viewModel.showAlerts = true
                    viewModel.locationManager.checkLocationAuthorization()
                }
        }
        .modifier(ContentPad())
        .padding(.horizontal)
        .onAppear {
            viewModel.showAlerts = false
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK") { }
        }
    }
    
    init(userCustomLocation: Coordinate2D? = nil) {
        guard let userCustomLocation else {
            self.viewModel = MapViewModel(editingLocation: userCustomLocation)
            return
        }
        self.viewModel = MapViewModel(editingLocation: userCustomLocation, isIncludingLocation: true)
    }
    
}

#Preview {
    MapView()
}
