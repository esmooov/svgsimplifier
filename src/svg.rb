# Ruby internal object representation of an SVG diagram
require 'svg_point'

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

	def convert
		@svg["svg"]["path"].each do |dist|

			dist["array_of_paths"] = to_path_array(dist["d"])
			dist["array_of_path_points"] = []
			dist["array_of_paths"].collect! do |path|				
				to_path_point_array(path)	
			end
		end
	end

	private

	def curves_to_lines(point_array,resolution)
		point_array.collect! do |point|
		end
	end

	def to_path_array(path)
		path.scan(/[MCL].+z/).flatten()
	end

	def to_path_point_array(path)
		path.gsub!(/(?=[^\s]|^)([A-Za-z])(?=$|[^\s])/){|q| " #{$1} "}
		path.gsub!(/  /, ' ')
		q = path.split(/ /).reject{|q| q === ""};

		stack = []
		points = []

		q.each do |f|
			if stack.length > 0 && f =~ /[MCLSz]/
				points << to_svg(stack)
				stack = []
			end

			stack << f
		end

		points
	end

	def to_svg(stack)
		if stack[0] == "C"
			a = SVGPoint.new(stack[0],Point.new(stack[3]),Point.new(stack[1]),Point.new(stack[2]))
		else
			a = SVGPoint.new(stack[0],Point.new(stack[1]))
		end
	end

end
