//
//  Game+Transferable.swift
//
//
//  Created by Nick Baughan on 09/05/2024.
//

import CoreTransferable
import UniformTypeIdentifiers

public struct GameTransfer: Transferable {
    public let fileURL: URL
    public let stableIdentifier: UUID
    public let url: URL
    public let schemeURL: URL
    public let title: String
    
    public static var transferRepresentation: some TransferRepresentation {
        
//        CodableRepresentation(for: UUID.self, contentType: .game)
        FileRepresentation(
            exportedContentType: .game,
            shouldAllowToOpenInPlace: false)
        { game in
//            let url = try GameFile.Version1(from: game).url()
            return SentTransferredFile(game.fileURL)
        }
        
        ProxyRepresentation(exporting: {
            CustomModelID(id: $0.stableIdentifier)
        })
        .visibility(.ownProcess)
        
        ProxyRepresentation(exporting: \.url)
        ProxyRepresentation(exporting: \.schemeURL)
        
        ProxyRepresentation(exporting: \.title)
    }
}
