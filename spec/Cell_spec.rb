require 'spec_helper'


describe Cell do

	cell = Cell.new

	it "initialize cell" do
		expect(cell.state).to eq Cell::CELL_EMPTY
	end

	it "should display the cell" do
			expect(cell.to_s).to eq "░"

			cell.state = Cell::CELL_WHITE
			expect(cell.to_s).to eq "W"

			cell.state = Cell::CELL_CROSSED
			expect(cell.to_s).to eq "X"

			cell.state = Cell::CELL_BLACK
			expect(cell.to_s).to eq "█"
	end


	it "test all cell states" do
		cell.state = Cell::CELL_BLACK
		expect(cell.state).to eq Cell::CELL_BLACK

		cell.state = Cell::CELL_WHITE
		expect(cell.state).to eq Cell::CELL_WHITE

		cell.state = Cell::CELL_CROSSED
		expect(cell.state).to eq Cell::CELL_CROSSED
	end

	it "should raise" do
    	expect{cell.state=3}.to raise_error(ArgumentError)
	end


end