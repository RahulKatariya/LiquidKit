//
//  TagTests.swift
//  LiquidTests
//
//  Created by Bruno Philipe on 12/10/18.
//

import XCTest
@testable import LiquidKit

class TagTests: XCTestCase
{
	func testTagAssign()
	{
		let lexer = Lexer(templateString: "{% assign filename = \"/index.html\" %}{{ filename }}{% assign reversed = \"abc\" | split: \"\" | reverse | join: \"\" %}{{ reversed }}")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["/index.html", "cba"])
	}

	func testTagIncrement()
	{
		let lexer = Lexer(templateString: "{% increment counter %}{% increment counter %}{% increment counter %}")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["0", "1", "2"])
	}

	func testTagDecrement()
	{
		let lexer = Lexer(templateString: "{% decrement counter %}{% decrement counter %}{% decrement counter %}")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["-1", "-2", "-3"])
	}

	func testTagIncrementDecrement()
	{
		let lexer = Lexer(templateString: "{% decrement counter %}{% decrement counter %}{% decrement counter %}{% increment counter %}{% increment counter %}{% increment counter %}")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["-1", "-2", "-3", "-3", "-2", "-1"])
	}

	func testTagIfEndIf()
	{
		let lexer = Lexer(templateString: "<p>{% assign check = false %}{% if check %}{% if check %}10{% endif %}20{% endif %}</p>")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["<p>", "</p>"])
	}

	func testTagIfEndIf_inverse()
	{
		let lexer = Lexer(templateString: "<p>{% assign check = true %}{% if check %}{% if check %}10{% endif %}20{% endif %}</p>")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["<p>", "10", "20", "</p>"])
	}

	func testTagIfElseEndIf()
	{
		let lexer = Lexer(templateString: "<p>{% assign check = false %}{% if check %}10{% else %}20{% endif %}</p>")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["<p>", "20", "</p>"])
	}

	func testTagIfElseEndIf_inverse()
	{
		let lexer = Lexer(templateString: "<p>{% assign check = true %}{% if check %}10{% else %}20{% endif %}</p>")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["<p>", "10", "</p>"])
	}

	func testTagIfElseIfEndIf()
	{
		let lexer = Lexer(templateString: "<p>{% assign check = false %}{% assign check_inverse = true %}{% if check %}10{% elsif check_inverse %}20{% endif %}</p>")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["<p>", "20", "</p>"])
	}

	func testTagIfElseIfEndIf_inverse()
	{
		let lexer = Lexer(templateString: "<p>{% assign check = true %}{% assign check_inverse = false %}{% if check %}10{% elsif check_inverse %}20{% endif %}</p>")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["<p>", "10", "</p>"])
	}

	func testChainedTagElseIf()
	{
		let lexer = Lexer(templateString: "<p>{% assign check = false %}{% assign check_inverse = true %}{% if check %}10{% elsif check %}20{% elsif check_inverse %}30{% endif %}</p>")
		let tokens = lexer.tokenize()
		let parser = TokenParser(tokens: tokens, context: Context())
		let res = parser.parse()
		XCTAssertEqual(res, ["<p>", "30", "</p>"])
	}
}