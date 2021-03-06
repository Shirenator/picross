require_relative 'Setting'
require_relative 'SettingKey'

class SettingKeyboard < Setting

	attr_reader :keyboardChoosers

	def initialize(user, parent)
		@user = user

		@keys = Gtk::Grid.new()
		@keys.column_spacing = 5

		@keyboardBind = @user.settings.picrossKeys

		@keyboardChoosers = []
		@keyboardBind.each do |keyName, value|
			@keyboardChoosers << SettingKey.new(parent, @user, keyName, @keyboardBind)
		end

		line = 0
		@keyboardChoosers.each do |keyChooser|
			@keys.attach(keyChooser.label,  0, line, 1, 1)
			@keys.attach(keyChooser.widget, 1, line, 1, 1)
			line += 1
		end

		super(@user.lang["option"]["chooseKeyboard"], @keys)
	end

	def save
		@keyboardChoosers.each do |keyChooser|
			keyChooser.save
		end
	end

end
