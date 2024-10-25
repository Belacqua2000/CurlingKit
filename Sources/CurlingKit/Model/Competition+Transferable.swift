//
//  Competition+Transferable.swift
//  CurlingKit
//
//  Created by Nick Baughan on 24/10/2024.
//

import CoreTransferable

extension Competition: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        
        ProxyRepresentation(exporting: {
            CustomModelID(id: $0.stableIdentifier)
        })
        .visibility(.ownProcess)
        
        ProxyRepresentation(exporting: \.url)
        ProxyRepresentation(exporting: \.title)
    }
}
