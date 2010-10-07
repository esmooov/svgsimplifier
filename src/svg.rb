# Ruby internal object representation of an SVG diagram
require 'rubygems'
require 'svg_point'
require 'enumerator'
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

	def convert

		@svg["svg"]["path"].each do |dist|

			dist["array_of_paths"] = to_path_array(dist["d"])
			dist["array_of_path_points"] = []
			dist["array_of_paths"].collect! do |path|				
				to_path_point_array(path)	
			end

		end

	end

#private

    def curves_to_lines(point_array,resolution)
       
       output = []
       point_array.enum_with_index.collect do |point,index|

           if point.type == "C"

               step = 1/resolution


           else

               output << point

           end

       end

    end

    def bez_to_val(point,previous,t)

        x = previous.p.x + 3*t*(point.r1.x-previous.p.x)+3*t**2*(previous.p.x+point.r2.x-(2*point.r1.x))+t**3*(point.p.x-previous.p.x+3*point.r1.x-3*point.r2.x)
        y = previous.p.y + 3*t*(point.r1.y-previous.p.y)+3*t**2*(previous.p.y+point.r2.y-(2*point.r1.y))+t**3*(point.p.y-previous.p.y+3*point.r1.y-3*point.r2.y)
        new_point = Point.new(x,y)
        puts x,y

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
