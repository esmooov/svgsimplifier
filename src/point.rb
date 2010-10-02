# Simple point representation

class Point

	def initialize(x, y)
		@x = x
		@y = y
	end

	def to_s
		string = ""

		if @x && @y
			string += "#{@x},#{@y} "
		end

		return string
	end

	attr_accessor :x, :y

	@x
	@y
end

