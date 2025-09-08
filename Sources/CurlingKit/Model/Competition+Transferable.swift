//
//  Competition+Transferable.swift
//  CurlingKit
//
//  Created by Nick Baughan on 24/10/2024.
//

import CoreTransferable

public struct CompetitionTransfer: Transferable {
    public let stableIdentifier: UUID
    public let url: URL
    public let title: String
    public static var transferRepresentation: some TransferRepresentation {
        
        ProxyRepresentation(exporting: {
            CustomModelID(id: $0.stableIdentifier)
        })
        .visibility(.ownProcess)
        
        ProxyRepresentation(exporting: \.url)
        ProxyRepresentation(exporting: \.title)
    }
}
