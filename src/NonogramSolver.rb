class NonogramSolver

	def initialize (p)
		@data = p
		@rows = Array.new
		@cols = Array.new
	end

	def solve
		rowData = @data[0].split(" ")
		colData = @data[1].split(" ")

		@rows = self.getCandidates(rowData, colData.size)
		@cols = self.getCandidates(colData, rowData.size)

		begin
			numChanged = self.reduceMutual(@cols, @rows)
			if (numChanged == -1)
				puts "No solution"
				return
			end
		end while (numChanged > 0)
		
		@rows.each do |row|
			for i in 0...(@cols.size)
				print row[0][i]? "# " : ". "
			end
			print "\n"
		end
		puts
		return self
	end

	#collect all possible solutions for the given clues
	def getCandidates (data, len)
		result = Array.new
		data.each do |s|
			lst = Array.new
			sumChars = self.charsSum (s)
			
			prep = s.split(//).collect{|x| repeat(self.letterToInt(x),"1")} #list of blocks
			
			self.genSequence(prep, len - sumChars + 1).each do |r|
				bits = r[1,r.size-1].split(//)
				bitset = Array.new(bits.size,false)
				for i in 0...bits.size
					bitset[i] = (bits[i]=='1')
				end
				lst.push(bitset)
			end
			result.push(lst)
		end
		return result
	end

	#permutation generator, translated from Python via D
	#List<String> ones
	#int numZeros
	def genSequence(ones, numZeros)
		if ones.empty?
			return [self.repeat(numZeros, "0")]
		end

		result = Array.new
		for x in 1...(numZeros-ones.size+2)
			skipOne = ones.drop(1)
			genSequence(skipOne, numZeros - x).each do |tail|
				result.push(repeat(x,"0")+ones[0]+tail)
			end
		end
		return result
	end
	
	#returns int
	#List<List<BitSet>> cols
	#List<List<BitSet>> rows
	def reduceMutual(cols, rows)
		countRemoved1 = reduce(cols, rows)
		if (countRemoved1 == -1)
			return -1
		end

		countRemoved2 = reduce(rows, cols)
		if (countRemoved2 == -1)
			return -1
		end

		return countRemoved1 + countRemoved2
	end
	
	#returns int
	#List<List<BitSet>> a
	#List<List<BitSet>> b
	def reduce(a, b)
		countRemoved = 0
		for i in 0...(a.size)
			commonOn = Array.new(b.size,true)
			commonOff = Array.new(b.size,false)
			
			#determine which values all candidates of ai have in common
			a[i].each do |candidate|
				commonOn = self.bitSetAnd(commonOn,candidate)
				commonOff = self.bitSetOr(commonOff,candidate)
			end
			
			#remove from bj all candidates that dont share the forced values
			for j in 0...(b.size)
				fi = i
				fj = j
				
				if (b[j].reject! { |cnd| (commonOn[fj] && !cnd[fi]) || (!commonOff[fj] && cnd[fi]) } != nil)
					countRemoved +=1
				end
				if b[j].empty?
					return -1
				end
			end
		end
		return countRemoved
	end
	
	
	def letterToInt (c)
		return c.ord() -'A'.ord() + 1
	end
	
	def charsSum (s)
		sum = 0
		s.each_char { |c| sum += self.letterToInt(c) }
		return sum
	end
	
	def repeat (n, s)
		res = ""
		for i in 0...n
			res << s
		end
		return res
	end
	
	def bitSetAnd (a,b)
		result = Array.new
		for i in 0...(a.size)
			result[i] = a[i] && b[i] 
		end
		return result
	end
	
	def bitSetOr (a,b)
		result = Array.new
		for i in 0...(a.size)
			result[i] = a[i] || b[i] 
		end
		return result
	end
end

p1 = ["C BA CB BB F AE F A B", "AB CA AE GA E C D C"]
p2 = ["F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC", "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA"]
p3 = ["CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC", "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF AAAAD BDG CEF CBDB BBB FC"]
p4 = ["E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G", "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM"]

def convert (lins,cols)
	resLins = ""
	resCols = ""
	lins.each { |line|
		line.each { |b| resLins << ('A'.ord()+b-1).chr }
		resLins << " "
	}
	cols.each { |col|
		col.each { |b| resCols << ('A'.ord()+b-1).chr }
		resCols << " "
	}
	return [resLins[0,resLins.size-1],resCols[0,resCols.size-1]]
end

#Me
#lines = [[2,3,2],[1,4,4,1],[6,6],[15],[3,3,1,3],[3,1,1,5],[3,1,1,1,4],[3,3,1,5],[2,3,1,2],[1,11,1],[2,9,2],[3,7,3],[4,5,4],[5,3,5],[6,1,6]]
#clns = [[2,5,6],[1,7,5],[9,4],[3,2,3],[4,6,2],[5,6,1],[1,3,8],[1,1,6],[1,12],[3,4,1],[3,1,1,3,2],[3,3,2,3],[9,4],[1,7,5],[2,5,6]]

#Piou (fonctionne pas)
#lines = [[1],[3,2],[2,2,1,1],[2,2,4],[1,2,1,2],[2,2,2],[1,3],[2],[2,2],[1,1]]
#clns = [[1,2,1],[3,2,2],[1,2,1],[3,2,2],[2,2,1],[2,1,1],[2],[4],[1,2],[3],[1]]

#Tasse
#lines= [[1,1],[1,3],[10,1],[1,1,1],[1,3],[1,1],[10],[14]]
#clns= [[1],[1],[8],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[8],[1,1,1],[4,1]]

#Speaker
lines = [[2],[3],[2,1],[2,1],[3,1],[4,1,1],[1,1,1],[1,1,1],[1,1,1],[4,1,1],[3,1],[2,1],[2,1],[3],[2]]
clns = [[1,1],[1,1],[1,1],[7],[1,1],[9],[2,2],[2,2],[2,2],[15]]


[convert(lines,clns)].each do |p|
	solver = NonogramSolver.new(p)
	solver.solve
end