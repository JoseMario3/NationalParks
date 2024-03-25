//
//  ContentView.swift
//  Parks
//
//  Created by Jose Folgar on 3/24/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var parks: [Park] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(parks) { park in
                        NavigationLink(value: park) {
                            ParkRow(park: park)
                        }
                    }
                }
            }
            .navigationDestination(for: Park.self) { park in
                ParkDetailView(park: park)
            }
            .navigationTitle("National Parks")
        }
        .onAppear(perform: {
            Task {
                await fetchParks()
            }
        })
    }
    
    private func fetchParks() async {

        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=wa&api_key=a8j5hAjee8DLufnETw17YPCyMmsVazUOHTu1fgz9")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)
            let parks = parksResponse.data
            self.parks = parks
            for park in parks { print(park.fullName) }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ParkRow: View {
    let park: Park

    var body: some View {
        
        // Park row
        Rectangle()
            .aspectRatio(4/3, contentMode: .fit)
            .overlay {
                // TODO: Get image url
                let image = park.images.first
                let urlString = image?.url
                let url = urlString.flatMap { string in
                    URL(string: string)
                }
                
                // TODO: Add AsyncImage
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray4)
                }
            }
            .overlay(alignment: .bottomLeading) {
                Text(park.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
            }
            .cornerRadius(16)
            .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
