import SwiftData

@MainActor
public let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        sampleGames.forEach(container.mainContext.insert)
        
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}()

public let sampleGames: [Game] = {
    let game = Game(on: .now, against: "Dunfermline")
//    let stone1 = Stone(end: game.ends.first!, number: 1, shot: .draw, direction: .center, handle: .clockwise, iceAccuracy: .onTheBrush, weightAccuracy: .heavy)
    return [game]
}()

@MainActor
public let previewGame: Game = {
    try! previewContainer.mainContext.fetch(FetchDescriptor<Game>()).first!
}()

@MainActor
public let previewEnd: End = {
    let game = previewGame
    game.addEnd(using: previewContainer.mainContext)
    return game.ends!.first!
}()

//@MainActor
//let previewStone: Stone = {
//    try! previewContainer.mainContext.fetch(FetchDescriptor<Stone>()).first!
//}()
