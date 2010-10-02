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
			dist["array_of_path_points"] = []
			dist["array_of_paths"].each do |path|				
				dist["array_of_path_points"] << to_path_point_array(path)	
			end

		end

	end

	def to_path_array(path)

		path.scan(/[MCL].+z/).flatten()

	end

	def to_path_point_array(path)

		path.gsub!(/(?=[^\s]|^)([A-Za-z])(?=$|[^\s])/){|q| " #{$1} "}

		q = path.split(/ /);

		stack = []

		q.each do |f|

			if stack.length > 0 && f =~ /[MCLSz]/
				do_something_with_stack(stack)
				stack = []
			end

			stack << f
		end

		if stack.length > 0 && f =~ /[MCLSz]/
			do_something_with_stack(stack)
			stack = []
		end

	end

	def do_something_with_stack(stack)

		puts stack.inspect

	end

end
