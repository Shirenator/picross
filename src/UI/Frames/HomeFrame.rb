require 'yaml'

require_relative '../Frame'

class HomeFrame < Frame

	def initialize(user)
		super()
		self.border_width = 100

		config = YAML.load(File.open("../config.yml"))
		lang = user.settings.language
		puts "\n" + lang + "\n"
		puts config["languages"]["fr"]

		@vbox = Gtk::Box.new(:vertical, 5)

		@playBtn = Gtk::Button.new(:label => config["languages"][lang]["play"])
		@rankBtn = Gtk::Button.new(:label => config["languages"][lang]["rank"])
		@ruleBtn = Gtk::Button.new(:label => config["languages"][lang]["rule"])
		@optionBtn = Gtk::Button.new(:label => config["languages"][lang]["option"])
		@exitBtn = Gtk::Button.new(:label => config["languages"][lang]["exit"])

		@vbox.pack_start(@playBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@rankBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@ruleBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@optionBtn, :expand => true, :fill => true, :padding =>2)
		@vbox.pack_start(@exitBtn, :expand => true, :fill => true, :padding =>2)

		@playBtn.signal_connect("clicked") do
			self.parent.setFrame(GameFrame.new(Map.load('../test.map')))
		end
		add(@vbox)
	end
end
