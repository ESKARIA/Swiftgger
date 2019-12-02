//
//  OpenAPISecurityBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

/**
    Tests for security schemes list (/components/securitySchemes).

    ```
    components: {
        "securitySchemes" : {
            "auth_jwt" : {
                "bearerFormat" : "jwt",
                "in" : "header",
                "type" : "http",
                "description" : "You can get token from *sign-in* action from *Account* controller.",
                "scheme" : "bearer"
            }
        }
    }
    ```
 */
class OpenAPISecurityBuilderTests: XCTestCase {

    func testBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.basic(description: "Basic authorization")]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_basic"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("basic", securitySchema?.scheme)
        XCTAssertEqual("Basic authorization", securitySchema?.description)
    }

    func testJWTAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.jwt(description: "JWT authorization")]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_jwt"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("bearer", securitySchema?.scheme)
        XCTAssertEqual("jwt", securitySchema?.bearerFormat)
        XCTAssertEqual("JWT authorization", securitySchema?.description)
    }

    func testJWTAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.jwt(description: "JWT authorization")]
        )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                    APIAction(method: .get, route: "/animals", summary: "Action summary",
                        description: "Action description", authorization: true)
                    ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["auth_jwt"], "Bearer authorization should be enabled")

    }

    func testBasicAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.basic(description: "Basic authorization")]
        )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                    APIAction(method: .get, route: "/animals", summary: "Action summary",
                        description: "Action description", authorization: true)
                    ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["auth_basic"], "Basic authorization should be enabled")
    }

    func testBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.bearer(description: "Bearer authorization")]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_bearer"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("bearer", securitySchema?.scheme)
        XCTAssertEqual("Bearer authorization", securitySchema?.description)
    }

    func testBearerAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.bearer(description: "Bearer authorization")]
        )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                    APIAction(method: .get, route: "/animals", summary: "Action summary",
                        description: "Action description", authorization: true)
                    ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["auth_bearer"], "Bearer authorization should be enabled")

    }

    static var allTests = [
        ("testBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument", testBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testBasicAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument", testBasicAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument),
        ("testJWTAuthorizationsShouldBeTranslatedToOpenAPIDocument", testJWTAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testJWTAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument", testJWTAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument),
        ("testBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument", testBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testBearerAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument", testBearerAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument)
    ]
}
