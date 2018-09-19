//
//  Context.swift
//  Liquid
//
//  Created by YourtionGuo on 28/06/2017.
//
//
/// A container for template variables.
public class Context
{
    private var variables: [String: Token.Value]
	private var counters: [String: Int] = [:]

    public init(dictionary: [String: Token.Value]? = nil)
	{
		variables = dictionary ?? [:]
    }
	
	public init(dictionary: [String: Any?])
	{
		variables = [:]
		
		for (key, value) in dictionary
		{
			if let value = parseValue(value)
			{
				variables[key] = value
			}
		}
	}
	
	public func getValue(for key: String) -> Token.Value?
	{
		return variables[key]
	}
	
	public func set(value: Token.Value, for key: String)
	{
		variables[key] = value
	}
	
	public func set(value: Any?, for key: String)
	{
		
		if let value = parseValue(value)
		{
			variables[key] = value
		}
	}

	/// Creates a new number variable, and increases its value by one every time it is called. The initial value is 0.
	public func incrementCounter(for key: String) -> Int
	{
		let counter = counters[key] ?? 0
		counters[key] = counter + 1
		return counter
	}

	/// Creates a new number variable, and decreases its value by one every time it is called. The initial value is -1.
	public func decrementCounter(for key: String) -> Int
	{
		let counter = (counters[key] ?? 0) - 1
		counters[key] = counter
		return counter
	}
	
	private func parseValue(_ value: Any?) -> Token.Value?
	{
		if let intLiteral = value as? IntegerLiteralType
		{
			return .decimal(Decimal(integerLiteral: intLiteral))
		}
		else if let floatLiteral = value as? FloatLiteralType
		{
			return .decimal(Decimal(floatLiteral: floatLiteral))
		}
		else if let string = value as? String
		{
			return .string(string)
		}
		else if let boolLiteral = value as? BooleanLiteralType
		{
			return .bool(boolLiteral)
		}
		else if value == nil
		{
			return .nil
		}
		else
		{
			return nil
		}
	}

	func valueOrLiteral(for token: String) -> Token.Value?
	{
		let trimmedToken = token.trimmingWhitespaces

		if trimmedToken == "true"
		{
			return .bool(true)
		}
		else if trimmedToken == "false"
		{
			return .bool(false)
		}
		else if trimmedToken.hasPrefix("\""), trimmedToken.hasSuffix("\"")
		{
			// This is a literal string. Strip its quotations.
			return .string(trimmedToken.trim(character: "\""))
		}
		else if let integer = Int(trimmedToken)
		{
			// This is an integer literal (the integer constructor fails if a decimal point is found).
			return .integer(integer)
		}
		else if let number = Decimal(string: trimmedToken)
		{
			// This is a decimal literal.
			return .decimal(number)
		}
		else
		{
			// This is a variable name. Return its value, or an empty string.
			return getValue(for: trimmedToken)
		}
	}
}
