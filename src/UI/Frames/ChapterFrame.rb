require 'yaml'

require_relative 'MapFrame'
require_relative 'HomeFrame'
require_relative '../Frame'

##
# File          :: ChapterFrame.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/16/2018
# Last update   :: 02/16/2018
# Version       :: 0.1
#
# This class represents the ChapterFrame which list all chapter of an user
class ChapterFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

		# Create vertical box containing all chapters buttons
		@vbox = Gtk::Box.new(:vertical, user.chapters.length)

		# Create a return button
		@returnBtn = Gtk::Button.new()
		@returnBtn.image = AssetsLoader.loadImage("arrow-left.png", 40)
		@returnBtn.relief = Gtk::ReliefStyle::NONE
		@vbox.pack_start(@returnBtn, :expand => true, :fill => true, :padding =>2)

		# List of bouttons
		@buttonsList = Array.new(user.chapters.length + 1)

		user.chapters.each_index do |x|
			chapter = user.chapters[x]

			@buttonsList[x] = Gtk::Button.new

			if chapter.unlocked?(user) then
				@buttonsList[x].label = chapter.title
				@buttonsList[x].signal_connect("clicked") do
					self.parent.setFrame(MapFrame.new(user, chapter))
				end
			else
				buttonBox = Gtk::Box.new(:horizontal)
				buttonBox.pack_start(AssetsLoader.loadImage("lock.png", 20), :expand => true, :fill => true, :padding =>2)
				buttonBox.pack_start(Gtk::Label.new("#{user.totalStars}/#{chapter.starsRequired}"), :expand => false, :fill => false, :padding =>2)
				buttonBox.pack_start(AssetsLoader.loadImage("star.png", 20), :expand => false, :fill => false, :padding =>2)
				@buttonsList[x].add(buttonBox)
				puts chapter.starsRequired
			end

			@vbox.pack_start(@buttonsList[x], :expand => true, :fill => true, :padding => 2)
		end

		@returnBtn.signal_connect("clicked") do
			self.parent.setFrame(HomeFrame.new(user))
		end

		# Add vbox to frame
		add(@vbox)

	end
end
