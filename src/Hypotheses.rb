require_relative 'Hypothesis'
require_relative 'Grid'
require_relative 'Cell'

##
# File          :: Hypotheses.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 01/27/2018
# Version       :: 0.1
#
# This class represents hypotheses. This is a stack of hypothesis.
# It is possible to create new hypothesis that are based on the
# precedent hypothesis. Each hypothesis can also be validated or
# rejected.
class Hypotheses

	# +lines+   - The number of lines of every hypothesis in the stack
	# +columns+ - The number of columns of every hypothesis in the stack
	# +stack+   - An array of hypothesis used as a stack

	##
	# Creation of a stack of hypothesis, ie an Hypotheses.
	# This automatically create a default hypothesis, with an empty grid
	# inside.
	# * *Arguments* :
	#   - +lines+   -> the number of line of the hypotheses
	#   - +columns+ -> the number of columns of the hypotheses
	def initialize(lines, columns)
		@stack   = Array.new()
		@lines   = lines
		@columns = columns

		# We create and push the default hypothesis
		defaultHypothesis      = Hypothesis.new(nil, 0)
		defaultGrid            = Grid.new(lines, columns, defaultHypothesis)
		defaultHypothesis.grid = defaultGrid
		@stack.push(defaultHypothesis)
	end

	##
	# Return the working hypothesis, the hypothesis that is
	# at the top of the stack.
	# * *Returns* :
	#   - the working hypothesis
	def getWorkingHypothesis()
		return @stack.last
	end

	##
	# Create and add a new hypothesis to the stack of hypotheses.
	# * *Returns* :
	#   - the id of the created hypothesis in the stack
	def addNewHypothesis()
		newGrid = getWorkingHypothesis.grid.clone
		newHypothesis = Hypothesis.new(newGrid, getWorkingHypothesis.id + 1)
		newGrid.each_cell do |cell|
			cell.nextHypothesis = newHypothesis
		end
		@stack.push(newHypothesis)
		return @stack.length - 1
	end

	##
	# Reject the hypothesis identified by its ID.
	# This will also reject all hypothesis that are based on
	# the rejected hypothesis.
	# Rejection: the hypothesis is destroyed, changing the current working
	# hypothesis to the previous one.
	# * *Arguments* :
	#   - +hypothesisID+ -> the id of the hypothesis to reject
	# * *Returns* :
	#   - the object itself
	# * *Raises* :
	#   - +ArgumentError+ -> if +hypothesisID+ is not a valid ID in the stack
	def reject(hypothesisID)
		if hypothesisID < 0 or hypothesisID >= @stack.length then
			raise ArgumentError, "hypothesisID is not a valid ID in the stack"
		end
		if hypothesisID == 0 then
			raise ArgumentError "hypothesis 0 cannot be rejected"
		end
		@stack.pop(@stack.length - hypothesisID)
		return self
	end

	##
	# Validate the hypothesis identified by the given id.
	# This will also validate all other hypothesis previous to this one.
	# Validation: the hypothesis is fusionned with the lower one.
	# * *Arguments* :
	#   - +hypothesisID+ -> the id of the hypothesis to validate
	# * *Returns* :
	#   - the object itself
	# * *Raises* :
	#   - +ArgumentError+ -> if +hypothesisID+ is not a valid ID in the stack
	def validate(hypothesisID)
		if hypothesisID < 0 or hypothesisID >= @stack.length then
			raise ArgumentError, "hypothesisID is not a valid ID in the stack"
		end
		if hypothesisID == 0 then
			raise ArgumentError, "hypothesis 0 cannot be validated"
		end
#j'ai fait l'inverse, c'est pas id à 0, mais on virer tout jusqu'a hypothesisID
		newBaseGrid = @stack.last
		newBaseGrid.id = @stack[hypothesisID - 1].id
		@stack.slice!(hypothesisID - 1..-1)
		@stack.push(newBaseGrid)
		puts "len" +  @stack.length.to_s
		puts "hyps:" + self.to_s
		return self
	end

	##
	# Define each method for this class, allowing to go through all the hypothesis
	def each(&block)
		@stack.drop(1).each(&block)
	end

	##
	# Converts the hypotheses to a String, for printing
	# * *Returns* :
	#   - the hypotheses into a String
	def to_s()
		rslt = "\n\n\nPRINTING ALL HYPOTHESES (#{@stack.length}): \n"
		@stack.reverse.each_with_index do |hypothesis, index|
			rslt += "n° #{@stack.length - index - 1} : "+ hypothesis.to_s + "\n"
		end
		return rslt
	end

	##
	# Convert the hypotheses to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the hypotheses converted to an array
	def marshal_dump()
		return [@lines, @columns, @stack]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a hypotheses object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the hypotheses object itself
	def marshal_load(array)
		@lines, @columns, @stack = array
		return self
	end

end
