// App/Platforms/iOS/PhoneApp.swift
import SwiftUI
import AppUI // Импортируем наш модуль UI

@main
struct PhoneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() // Вызываем экран плеера
        }
    }
}
