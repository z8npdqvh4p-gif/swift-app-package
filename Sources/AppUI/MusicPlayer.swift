// Sources/AppUI/MusicPlayer.swift
import SwiftUI
import AVFoundation
import AppCore

@MainActor
public class MusicPlayer: ObservableObject {
    @Published public var tracks: [Track] = []
    @Published public var currentTrack: Track?
    @Published public var isPlaying = false
    @Published public var searchText = ""
    
    // Ссылка на аудио-плеер
    private var player: AVPlayer?
    
    // Твой Client ID (для тестов можно использовать 'a76862b2' или получить свой)
    private let clientId = "a76862b2" 
    
    public init() {
        // Загружаем треки при старте
        searchTracks(query: "lofi")
    }
    
    public func searchTracks(query: String? = nil) {
        let searchQuery = query ?? searchText
        let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: "https://api.jamendo.com/v3.0/tracks/?client_id=\(clientId)&format=jsonpretty&limit=10&search=\(encodedQuery)") else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(JamendoResponse.self, from: data)
                self.tracks = response.results
            } catch {
                print("Ошибка загрузки: \(error)")
            }
        }
    }
    
    public func playTrack(_ track: Track) {
        currentTrack = track
        guard let url = URL(string: track.audio) else { return }
        
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
    }
    
    public func togglePlay() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    public func nextTrack() {
        guard let current = currentTrack, let index = tracks.firstIndex(of: current) else { return }
        let nextIndex = (index + 1) % tracks.count
        playTrack(tracks[nextIndex])
    }
    
    public func prevTrack() {
        guard let current = currentTrack, let index = tracks.firstIndex(of: current) else { return }
        let prevIndex = (index - 1 + tracks.count) % tracks.count
        playTrack(tracks[prevIndex])
    }
}
