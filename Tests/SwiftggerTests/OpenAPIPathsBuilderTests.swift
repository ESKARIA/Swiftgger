//
//  OpenAPIServersBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 27.03.2018.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class Animal {
    var name: String
    var age: Int?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

/*
    "paths":
    {
        "/animals": {
            "get": {
                "description": "Returns all pets from the system that the user has access to",
                "responses": {
                    "200": {          
                        "description": "A list of pets.",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "array",
                                    "items": {
                                        "$ref": "#/components/schemas/pet"
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "post": {
                "description": "Returns all pets from the system that the user has access to",
                "request": {
                    "object": {
                        "name": "Dog",
                        "age": 21
                    }
                }
                "responses": {
                    "200": {          
                        "description": "A list of pets."
                    }
                }
            }
        }
    }
*/
class OpenAPIPathsBuilderTests: XCTestCase {

    func testActionRouteShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"], "Action route should be added to the tree.")
    }

    func testActionMethodShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"], "Action method should be added to the tree.")
    }

    func testActionDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("Action description", openAPIDocument.paths["/animals"]?.get?.description)
    }

    func testActionCodeResponseShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description")
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"], "Action response code should be added to the tree.")
    }

    func testActionResponseDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description")
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("Response description", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.description)
    }

    func testActionResponseContentShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let animal = Animal(name: "Dog", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: animal)
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content, "Response content should be added to the tree.")
    }

    func testActionDefaultResponseContentTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let animal = Animal(name: "Dog", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: animal)
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"], 
            "Default response content type should be added to the tree.")
    }

    func testActionCustomResponseContentTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let animal = Animal(name: "Dog", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: animal, contentType: "application/xml")
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/xml"], 
            "Custom response content type should be added to the tree.")
    }

    func testActionResponseSchemaShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let animal = Animal(name: "Dog", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: animal)
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema, 
            "Response schema should be added to the tree.")
    }

    func testActionArrayResponseTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let animal = Animal(name: "Dog", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: [animal])
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("array", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.type)
    }

    func testActionObjectResponseReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let animal = Animal(name: "Dog", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: animal)
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.ref)
    }    

    func testActionArrayResponseReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let animal = Animal(name: "Dog", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description", object: [animal])
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.items?.ref)
    }    


    static var allTests = [
        ("testActionRouteShouldBeAddedToOpenAPIDocument", testActionRouteShouldBeAddedToOpenAPIDocument),
        ("testActionMethodShouldBeAddedToOpenAPIDocument", testActionMethodShouldBeAddedToOpenAPIDocument),
        ("testActionDescriptionShouldBeAddedToOpenAPIDocument", testActionDescriptionShouldBeAddedToOpenAPIDocument),
        ("testActionCodeResponseShouldBeAddedToOpenAPIDocument", testActionCodeResponseShouldBeAddedToOpenAPIDocument),
        ("testActionResponseDescriptionShouldBeAddedToOpenAPIDocument", testActionResponseDescriptionShouldBeAddedToOpenAPIDocument),
        ("testActionResponseContentShouldBeAddedToOpenAPIDocument", testActionResponseContentShouldBeAddedToOpenAPIDocument),
        ("testActionDefaultResponseContentTypeShouldBeAddedToOpenAPIDocument", testActionDefaultResponseContentTypeShouldBeAddedToOpenAPIDocument),
        ("testActionCustomResponseContentTypeShouldBeAddedToOpenAPIDocument", testActionCustomResponseContentTypeShouldBeAddedToOpenAPIDocument),
        ("testActionResponseSchemaShouldBeAddedToOpenAPIDocument", testActionResponseSchemaShouldBeAddedToOpenAPIDocument),
        ("testActionArrayResponseTypeShouldBeAddedToOpenAPIDocument", testActionArrayResponseTypeShouldBeAddedToOpenAPIDocument),
        ("testActionObjectResponseReferenceShouldBeAddedToOpenAPIDocument", testActionObjectResponseReferenceShouldBeAddedToOpenAPIDocument),
        ("testActionArrayResponseReferenceShouldBeAddedToOpenAPIDocument", testActionArrayResponseReferenceShouldBeAddedToOpenAPIDocument)
    ]
}