require_relative '../Window'

class MainWindow < Window

	def initialize(application)
		super(application)
		set_title "Ruþycross"
		set_window_position :center
		override_background_color([:normal], Gdk::RGBA.new(4793, 4739, 10, 10))
	end

	def mainWindow?()
		return true
	end

end
