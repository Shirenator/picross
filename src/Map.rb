## 
# File          :: Map.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 01/27/2018
# Version       :: 0.1
#
# This class represents a map in a *Picross*.  
# A map has an estimated time to be done, a difficulty, a stack of 
# hypotheses (Hypotheses object), and a solution grid.
# Every map can be saved to a file, and then loaded back, using Marshal.

class Map

	# The hypotheses stack used to allow the player to do hypotheses about the solution
	attr_reader :hypotheses

	# +timeToDo+    - The estimated time to resolve the game
	# +difficulty+  - The estimated difficulty of the map
	# +solution+    - The solution (a Grid) of the map
	# +clmSolution+ - The numbers representing the columns solution (An array of arrays)
	# +lneSolution+ - The numbers representing the lines solution (An array of arrays) 

	##
	# Create a new map object
	# * *Arguments* :
	#   - +name+         -> a String representing the name of the map
	#   - +timeToDo+     -> estimated time to resolve the map
	#   - +difficulty+   -> estimated difficulty of the map
	#   - +lines+        -> number of lines of the map
	#   - +columns+      -> number of columns of the map
	#   - +solutionGrid+ -> the Grid representing the solution
	def initialize(name, timeToDo, difficulty, lines, columns, solutionGrid)
		@name        = name
		@timeToDo    = timeToDo
		@difficulty  = difficulty
		@hypotheses  = Hypotheses.new(lines, columns)
		@solution    = solutionGrid
		@clmSolution = computeColumnSolution(@solution)
		@lneSolution = computeLineSolution(@solution)
	end

	##
	#
	def Map.load(fileName)
		return Marshal.load(File.read(fileName))
	end

	##
	#
	def save(fileName)
		return File.open(fileName, 'w') { |f| f.write(Marshal.dump(self)) }
	end

	def reset()

	end

	##
	# Rotate the state of the cell on the higher hypothesis 
	# at given coordinates.
	# (CELL_WHITE -> CELL_BLACK -> CELL_CROSSED -> CELL_WHITE ... )
	# * *Arguments* :
	#   - +line+   -> the line of the cell to rotate
	#   - +column+ -> the column of the cell to rotate
	# * *Returns* :
	#   - the updated cell
	# * *Raises* : 
	#   - +InvalidCellPosition+ -> if given coordinates are invalid
	def rotateStateAt(line, column)
		hypothesis = @hypotheses.getWorkingHypothesis()
		cell = hypothesis.grid.getCellPosition(line, column)
		cell.stateRotate()
		cell.hypothesis = hypothesis
		return self
	end

	##
	# Convert the solution grid to columns numbers 
	# that help player to solve the game.
	# * *Arguments* : 
	#   - +solutionGrid+ -> the solution grid
	# * *Returns* :
	#   - the array containing the numbers composing the columns
	def computeColumnSolution(solutionGrid)
		columnSolution = Array.new(solutionGrid.columns) { Array.new() }

		0.upto(solutionGrid.columns - 1) do |i|
			size = 0
			0.upto(solutionGrid.lines - 1) do |j|
				if solutionGrid.grid[j][i].state == Cell::CELL_BLACK then
					size += 1
				elsif size != 0 then
					columnSolution[i].push(size)
					size = 0
				end
			end
			if size != 0 then
				columnSolution[i].push(size)
				size = 0
			end
		end
		return columnSolution
	end

	##
	# Convert the solution grid to lines numbers 
	# that help player to solve the game.
	# * *Arguments* : 
	#   - +solutionGrid+ -> the solution grid
	# * *Returns* :
	#   - the array containing the numbers composing the lines
	def computeLineSolution(solutionGrid)
		lineSolution = Array.new(solutionGrid.lines) { Array.new() }

		0.upto(solutionGrid.lines - 1) do |i|
			size = 0
			0.upto(solutionGrid.columns - 1) do |j|
				if solutionGrid.grid[i][j].state == Cell::CELL_BLACK then
					size += 1
				elsif size != 0 then
					lineSolution[i].push(size)
					size = 0
				end
			end
			if size != 0 then
				lineSolution[i].push(size)
				size = 0
			end
		end
		return lineSolution 
	end

	def help(helpType)

	end

	##
	# Retuns the map to a string, for debug only
	# * *Returns* :
	#   - the map into a String object
	def to_s()
		return "Difficulty: #{@difficulty}, time to do: #{@timeToDo}, hypotheses: #{@hypotheses}, solution: #{@solution}"
	end

	##
	# Convert the map to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the map converted to an array
	def marshal_dump()
		return [@name, @timeToDo, @difficulty, @hypotheses, @solution, @clmSolution, @lneSolution]
	end

	##
	# Update all the instances variables from the array given, 
	# allowing Marshal to load a map object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the map object itself
	def marshal_load(array)
		@name, @timeToDo, @difficulty, @hypotheses, @solution, @clmSolution, @lneSolution = array
		return self
	end

end