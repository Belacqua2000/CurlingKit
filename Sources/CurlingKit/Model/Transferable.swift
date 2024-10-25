//
//  Transferable.swift
//  CurlingKit
//
//  Created by Nick Baughan on 25/10/2024.
//

import CoreTransferable

public struct CustomModelID: Transferable {
    public let id: UUID
    public static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.id.uuidString) {
            if let id = UUID(uuidString: $0) {
                return CustomModelID(id: id)
            } else {
                throw TransferableError.invalidIDString(string: $0)
            }
        }
    }
}

enum TransferableError: Error {
    case invalidIDString(string: String)
}
