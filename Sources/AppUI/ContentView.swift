ContentView.swift// Sources/AppUI/ContentView.swift
import SwiftUI
import Neumorphic
import AppCore

public struct ContentView: View {
    @StateObject private var player = MusicPlayer()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Фон (важно для неоморфизма)
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Заголовок
                Text("Neumorphic Vibes")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top)
                
                // Поиск
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Search...", text: $player.searchText)
                        .onSubmit {
                            player.searchTracks()
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15).fill(Color.Neumorphic.main).softInnerShadow(RoundedRectangle(cornerRadius: 15))
                )
                .padding(.horizontal)
                
                // Обложка (большой диск)
                ZStack {
                    Circle()
                        .fill(Color.Neumorphic.main)
                        .softOuterShadow()
                        .frame(width: 250, height: 250)
                    
                    if let image = player.currentTrack?.image, let url = URL(string: image) {
                        AsyncImage(url: url) { phase in
                            if let img = phase.image {
                                img.resizable().clipShape(Circle())
                            } else {
                                Image(systemName: "music.note").font(.largeTitle).foregroundColor(.gray)
                            }
                        }
                        .frame(width: 230, height: 230)
                    } else {
                        Image(systemName: "music.note").font(.system(size: 80)).foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 30)
                
                // Название трека
                VStack(spacing: 5) {
                    Text(player.currentTrack?.name ?? "Choose a track")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.Neumorphic.secondary)
                    
                    Text(player.currentTrack?.artist_name ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Кнопки управления
                HStack(spacing: 40) {
                    Button(action: { player.prevTrack() }) {
                        Image(systemName: "backward.fill").font(.title2)
                    }
                    .softButtonStyle(Circle(), padding: 20)
                    
                    Button(action: { player.togglePlay() }) {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue) // Акцент
                    }
                    .softButtonStyle(Circle(), padding: 30)
                    
                    Button(action: { player.nextTrack() }) {
                        Image(systemName: "forward.fill").font(.title2)
                    }
                    .softButtonStyle(Circle(), padding: 20)
                }
                .padding(.bottom, 30)
                
                // Список треков (снизу)
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(player.tracks) { track in
                            Button(action: { player.playTrack(track) }) {
                                HStack {
                                    AsyncImage(url: URL(string: track.image ?? "")) { i in i.resizable() } placeholder: { Color.gray }
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading) {
                                        Text(track.name).fontWeight(.bold).lineLimit(1)
                                        Text(track.artist_name).font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15).fill(Color.Neumorphic.main).softOuterShadow()
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
