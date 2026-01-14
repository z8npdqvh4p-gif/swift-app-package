// Sources/AppCore/Track.swift
import Foundation

// Модель трека для Jamendo API
public struct Track: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let artist_name: String
    public let image: String?
    public let audio: String
    public let duration: Int
    
    // API Jamendo возвращает ID как строку
    public init(id: String, name: String, artist_name: String, image: String?, audio: String, duration: Int) {
        self.id = id
        self.name = name
        self.artist_name = artist_name
        self.image = image
        self.audio = audio
        self.duration = duration
    }
}

// Ответ от API
public struct JamendoResponse: Codable {
    public let results: [Track]
}
