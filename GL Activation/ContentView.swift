
import CoreLocationUI
import CoreLocation
import MapKit
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @State private var willMoveToNextScreen = false
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center) {
                Color.white
                Image("ico-gps")
                    .offset(x: 0, y: -230)
                Text("Habilite a sua localização")
                    .multilineTextAlignment(.center)
                    .offset(x: 0, y: -250)
                    .font(.system(size: 25))
                
                Text("Sua localização é necessária para validar a  ativação dos dispositivos Group Link")
                    .multilineTextAlignment(.center)
                    .offset(x: 0, y: -220)
                
                LocationButton(.currentLocation) {
                    viewModel.requestAllowOnceLocationPermission()
                    self.willMoveToNextScreen = true
                }
                .foregroundColor(.white)
                .cornerRadius(20)
                .labelStyle(.titleOnly)
                .padding(.bottom, 40)
            }
            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $willMoveToNextScreen) { LoginView() }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -23.606852, longitude: -46.686554), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastestLocation = locations.first else {
            return
        }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: lastestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

struct LoginView : View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Placeholder")
                
            }
        }
    }
}
