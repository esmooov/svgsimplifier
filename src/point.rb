# Simple point representation

class Point

	def initialize(x, y=nil)
		if y == nil
			@x = (x||"").split(",")[0]
			@y = (x||"").split(",")[1]
		else
			@x = x
			@y = y
		end
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

