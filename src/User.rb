require 'yaml'

require_relative 'UserSettings'
require_relative 'Chapter'

##
# File			:: User.rb
# Author		:: COHEN Mehdi
# Licence		:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 02/12/2018
#
# This class represents a user's profile
#
class User

	# +name+			- player's name
	# +settings+		- player's settings
	# +availableHelps+	- amount of help that the player can spend

	attr_accessor :name

	attr_reader :settings
	
	attr_reader :availableHelps
	
	attr_reader :chapters

	attr_writer :lang
	attr_reader :lang

	##
	# Creates a new User object
	# * *Arguments* :
	#   - +name+		-> a String representing the user's name
	def initialize(name, chapters)
		@name     = name
		@settings = UserSettings.new(self)
		@availableHelps = 0
		@chapters = chapters
		@lang     = self.languageConfig
	end

	##
	# Load a YAML file corresponding to a language name
	# * *Arguments* :
	#   - +langName+ -> the name of the language to load (english for example)
	# * *Returns* :
	#   - the language converted to Hashs
	def User.loadLang(langName)
		# set path to config file folder
		path = File.dirname(__FILE__) + "/../Config/"
		# Retrieve associated language config file
		configFile = File.expand_path(path + "lang_#{langName}")
		return YAML.load(File.open(configFile))
	end

	def User.languagesName
		path = File.dirname(__FILE__) + "/../Config/"
		names = []
		Dir.entries(path).each do |file|
			name = file.partition('lang_')[2]
			names.push(name) if name != ""
		end
		return names
	end

	##
	# Return a default language (english)
	# * *Returns*
	#   - a Hash of the english language
	def User.defaultLang()
		return User.loadLang('english')	
	end
	
	##
	# Return the language of the user. You should not use this method,
	# use instead the +lang+ method, this methods load the file every time you
	# call it.
	# * *Returns*
	#   - a Hash of the user language
	def languageConfig
		return User.loadLang(self.settings.language)
	end

	##
	# Returns the total stars of this user
	# Warning: if you frequently use this method, consider 
	# memorizing the value of it, it is calculated every time you call it.
	# * *Returns* :
	#   - the total stars of the user
	def totalStars
		stars = 0
		@chapters.each do |chapter|
			chapter.levels.each do |level|
				bestStat = level.allStat.maxStars
				if bestStat != nil then
					stars += bestStat.numberOfStars 
				end
	 		end
		end
		return stars
	end

	##
	# Adds an amount of helps to the available help count
	# * *Arguments* :
	#   - +amount+		-> a Fixnum representing an amount of help
	def addHelp(amount)
		unless (amount < 0)
			@availableHelps += amount
		else
			raise NegativeAmountException
		end
	end

	##
	# removes an amount of helps to the available help count
	# * *Arguments* :
	#   - +amount+		-> a Fixnum representing an amount of help
	def removeHelp (amount)
		unless (amount < 0)
			@availableHelps += amount
		else
			raise NegativeAmountException
		end
	end

	def save()
		#print(Dir.pwd)
		path = File.expand_path(File.dirname(__FILE__) + '/' + "../Users/User_#{@name}")
		File.open(path, 'w'){|f| f.write(Marshal.dump(self))}
		return self
	end

	def User.load(filename)
		return Marshal.load(File.read(filename))
	end
	##
	#
	def marshal_dump()
		[@name, @settings, @availableHelps, @chapters]
	end

	##
	#
	def marshal_load(array)
		@name, @settings, @availableHelps, @chapters = array
		@lang = languageConfig
		return self
	end
end
