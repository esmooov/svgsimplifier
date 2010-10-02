# Ruby internal object representation of an SVG diagram

require 'rubygems'
require 'crack'

class SVG

	def initialize(source) 
		
		str = ""
		begin
			File.open(source,"r") do |f|
				str = f.read
			end
		rescue
			str = source
		end

		@svg = Crack::XML.parse(str)

	end

	def to_s
		
		@svg.inspect

	end

end
