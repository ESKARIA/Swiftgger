//
//  OpenAPIObjectReferenceBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Builder of `paths` part of OpenAPI.
class OpenAPIMediaTypeBuilder {
    let objects: [APIObject]
    let object: Any.Type
    let isArray: Bool

    init(objects: [APIObject], for object: Any.Type, isArray: Bool = false) {
        self.objects = objects
        self.object = object
        self.isArray = isArray
    }

    func built() -> OpenAPIMediaType {

        let objectTypeReference = self.createObjectReference(for: self.object)

        var openAPISchema: OpenAPISchema?
        if isArray {
            let objectInArraySchema = OpenAPISchema(ref: objectTypeReference)
            openAPISchema = OpenAPISchema(type: "array", items: objectInArraySchema)
        } else {
            openAPISchema = OpenAPISchema(ref: objectTypeReference)
        }

        let openAPIMediaType = OpenAPIMediaType(schema: openAPISchema)
        return openAPIMediaType
    }

    func createObjectReference(for _type: Any.Type) -> String {
        let typeName = String(reflecting: _type).components(separatedBy: "App.").last ?? String(describing: _type)
//        let requestMirror: Mirror = Mirror(reflecting: _type)
//        let typeName = String(describing: requestMirror.subjectType)


        guard let object = self.objects.first(where: { $0.defaultName == typeName }) else {
            return "#/components/schemas/\(typeName)"
        }

        let schemaTypeName = object.customName ?? object.defaultName
        return "#/components/schemas/\(schemaTypeName)"
    }
}
