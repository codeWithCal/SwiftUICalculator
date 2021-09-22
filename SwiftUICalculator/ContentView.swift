//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by CallumHill on 19/9/21.
//

import SwiftUI

struct ContentView: View
{
	let grid = [
		["AC", "⌦", "%", "/"],
		["7", "8", "9", "X"],
		["4", "5", "6", "-"],
		["1", "2", "3", "+"],
		[".", "0", "", "="]
	]
	
	let operators = ["/", "+", "X", "%"]
	
	@State var visibleWorkings = ""
	@State var visibleResults = ""
	@State var showAlert = false
	
    var body: some View
	{
		VStack
		{
			HStack
			{
				Spacer()
				Text(visibleWorkings)
					.padding()
					.foregroundColor(Color.white)
					.font(.system(size: 30, weight: .heavy))
			}.frame(maxWidth: .infinity, maxHeight: .infinity)
			HStack
			{
				Spacer()
				Text(visibleResults)
					.padding()
					.foregroundColor(Color.white)
					.font(.system(size: 50, weight: .heavy))
			}.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			ForEach(grid, id: \.self)
			{
				row in
				HStack
				{
					ForEach(row, id: \.self)
					{
						cell in
						
						Button(action: { buttonPressed(cell: cell)}, label: {
							Text(cell)
								.foregroundColor(buttonColor(cell))
								.font(.system(size: 40, weight: .heavy))
								.frame(maxWidth: .infinity, maxHeight: .infinity)
							
						})
						
					}
				}
			}
			
			
			
		}
		.background(Color.black.ignoresSafeArea())
		.alert(isPresented: $showAlert)
		{
			Alert(
				title: Text("Invalid Input"),
				message: Text(visibleWorkings),
				dismissButton: .default(Text("Okay"))
			)
		}
    }
	
	func buttonColor(_ cell: String) -> Color
	{
		if(cell == "AC" || cell == "⌦")
		{
			return .red
		}
		
		if(cell == "-" || cell == "=" || operators.contains(cell))
		{
			return .orange
		}
		
		return .white
	}
	
	func buttonPressed(cell: String)
	{
		
		switch (cell)
		{
		case "AC":
			visibleWorkings = ""
			visibleResults = ""
		case "⌦":
			visibleWorkings = String(visibleWorkings.dropLast())
		case "=":
			visibleResults = calculateResults()
		case "-":
			addMinus()
		case "X", "/", "%", "+":
			addOperator(cell)
		default:
			visibleWorkings += cell
		}
		
	}
	
	func addOperator(_ cell : String)
	{
		if !visibleWorkings.isEmpty
		{
			let last = String(visibleWorkings.last!)
			if operators.contains(last)
			{
				visibleWorkings.removeLast()
			}
			visibleWorkings += cell
		}
	}
	
	func addMinus()
	{
		if visibleWorkings.isEmpty || visibleWorkings.last! != "-"
		{
			visibleWorkings += "-"
		}
	}
	
	func calculateResults() -> String
	{
		if(validInput())
		{
			var workings = visibleWorkings.replacingOccurrences(of: "%", with: "*0.01")
			workings = visibleWorkings.replacingOccurrences(of: "X", with: "*")
			let expression = NSExpression(format: workings)
			let result = expression.expressionValue(with: nil, context: nil) as! Double
			return formatResult(val: result)
		}
		showAlert = true
		return ""
	}
	func validInput() -> Bool
	{
		if(visibleWorkings.isEmpty)
		{
			return false
		}
		let last = String(visibleWorkings.last!)
		
		if(operators.contains(last) || last == "-")
		{
			if(last != "%" || visibleWorkings.count == 1)
			{
				return false
			}
		}
		
		return true
	}
	
	func formatResult(val : Double) -> String
	{
		if(val.truncatingRemainder(dividingBy: 1) == 0)
		{
			return String(format: "%.0f", val)
		}
		
		return String(format: "%.2f", val)
	}
	
	
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
