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
        
        FileRepresentation(
            exportedContentType: .game,
            shouldAllowToOpenInPlace: false)
        { game in
            let url = try GameFile.Version1(from: game).url()
            return SentTransferredFile(url)
        }
        
        ProxyRepresentation(exporting: \.title)
    }
}
