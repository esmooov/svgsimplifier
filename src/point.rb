# Simple point representation

class Point

	def initialize(x, y=nil)
		if y == nil
			@x = (x||"").split(",")[0].to_f
			@y = (x||"").split(",")[1].to_f
		else
			@x = x.to_f
			@y = y.to_f
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

