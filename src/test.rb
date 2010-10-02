require 'svg_point'

m = SVGPoint.new('M', Point.new(0,0))

l = SVGPoint.new('L', Point.new(1, 1))

c = SVGPoint.new('C', Point.new(4, 4), Point.new(1,2), Point.new(2, 1))

z = SVGPoint.new('z')

puts m.to_s + l.to_s + c.to_s + z.to_s

