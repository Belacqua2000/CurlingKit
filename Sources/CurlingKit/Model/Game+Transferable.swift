//
//  Game+Transferable.swift
//
//
//  Created by Nick Baughan on 09/05/2024.
//

import CoreTransferable
import UniformTypeIdentifiers

extension Game: Transferable {
    
    
    public static var transferRepresentation: some TransferRepresentation {
        
//        CodableRepresentation(for: UUID.self, contentType: .game)
        FileRepresentation(
            exportedContentType: .game,
            shouldAllowToOpenInPlace: false)
        { game in
            let url = try GameFile.Version1(from: game).url()
            return SentTransferredFile(url)
        }
        
        ProxyRepresentation(exporting: {
            CustomModelID(id: $0.stableIdentifier)
        })
        .visibility(.ownProcess)
        
        ProxyRepresentation(exporting: \.url)
        ProxyRepresentation(exporting: \.schemeUrl)
        
        ProxyRepresentation(exporting: \.title)
    }
}
