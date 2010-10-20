# SVG point element to simplify svg

require 'point'

class SVGPoint

	def initialize(type, p = nil, r1 = nil, r2 = nil, keep = true)
		@type = type
		@p = p
		@r1 = r1
		@r2 = r2
		@keep = keep
	end

	def to_s
		if keep
			return "#{type} #{r1}#{r2}#{p}"
		else
			return ""
		end
	end

	attr_accessor :type, :p, :r1, :r2, :keep

	@type
	@p
	@r1
	@r2
	@keep

end
