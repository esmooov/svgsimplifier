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
		@paths

	end

	def to_s
		
		@svg.inspect

	end

	def to_text_string_with_points
		
		@svg["svg"]["path"].each do |dist|
			
			dist["array_of_paths"] = to_path_array(dist["d"])
		
			dist["array_of_paths"].each do |path|				
				dist["array_of_path_points"] << to_path_point_array(path)	
			end

		end

	end

	def to_path_array(path)
		#M 245,459 L 206,641 C 270,728 333,815 397,902 C 397,902 398,902 398,901 L 402,900 L 405,9

		path.scan(/([MCL].+z)/)
		
	end
	
	def to_path_point_array(path)
	
	  path.gsub!(/(?=[^\s]|^)([A-Za-z])(?=$|[^\s])/){|q| " #{$1} "}
	  
	
	end

end
