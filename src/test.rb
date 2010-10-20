require "svg.rb"
a = SVG.new("M 0,0 L 1,0 L 2,1 L 3,3 L 4,0 L 5,1 L 6,3 z")
puts a
a.convert
a.simplify(0.5)
puts a.to_svg_string("simplified_lines")
