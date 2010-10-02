# SVG point element to simplify svg

require 'point'

class SVGPoint

	def initialize(type, p = Point.new(nil, nil), r1 = Point.new(nil, nil), r2 = Point.new(nil, nil), keep = false)
		
		@type = type
		@p = p
		@r1 = r1
		@r2 = r2
		@keep = keep

	end

	def to_s
		return "#{type} #{r1}#{r2}#{p}" 
	end

	attr_accessor :type, :p, :r1, :r2, :keep

	@type
	@p
	@r1
	@r2
	@keep

end
