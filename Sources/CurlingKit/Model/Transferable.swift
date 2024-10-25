//
//  Transferable.swift
//  CurlingKit
//
//  Created by Nick Baughan on 25/10/2024.
//

import CoreTransferable

public struct CustomModelID: Transferable {
    let id: UUID
    public static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.id.uuidString) {
            if let id = UUID(uuidString: $0) {
                return CustomModelID(id: id)
            } else {
                throw TransferableError.invalidUUID
            }
        }
    }
}

enum TransferableError: Error {
    case invalidUUID
}
