# Ruby internal object representation of an SVG diagram
require 'rubygems'
require 'svg_point'
require 'enumerator'
require 'crack'

class SVG

  attr_reader :svg
<<<<<<< HEAD
  def initialize(source) 

    str = ""
    begin
      File.open(source,"r") do |f|
=======

  def initialize(source)
    str = ""
    begin
      File.open(source, "r") do |f|
>>>>>>> juan/master
        str = f.read
      end
      @svg = Crack::XML.parse(str)
    rescue
      str = source
<<<<<<< HEAD
      @svg = {} 
=======
      @svg = {}
>>>>>>> juan/master
      @svg["svg"] = {}
      @svg["svg"]["path"] = [{"d"=>str}]
    end
  end

  def to_s
    @svg.inspect
  end

  def convert
    @svg["svg"]["path"].each do |dist|
      dist["array_of_paths"] = to_path_array(dist["d"])
      dist["array_of_paths"].collect! do |path|
        to_path_point_array(path)
      end
    end
  end

<<<<<<< HEAD
  end

  def to_s

    @svg.inspect

  end

  def convert
    @svg["svg"]["path"].each do |dist|
      dist["array_of_paths"] = to_path_array(dist["d"])
      dist["array_of_paths"].collect! do |path|				
        to_path_point_array(path)	
      end
    end
  end

  def decurve 
    @svg["svg"]["path"].each do |dist|
      dist["line_array"] = []
      dist["array_of_paths"].each do |path|
        dist["line_array"].push(convert_to_lines(path,3)) 
      end
    end
  end
  def reduce
    @svg["svg"]["path"].each do |dist|
      dist["final_line_array"] = []
      dist["line_array"].each do |path|

      end
    end
  end
  #private

  def enpeucker(point_array,start_index,end_index)
    cur_array = point_array[start_index..end_index]
    stack = []
    if cur_array[1..-2].length > 0
      max_point = cur_array[1..-2].max{|a,b| calculate_distance_from_line(cur_array[0],cur_array[-1],cur_array[a]) <=>  calculate_distance_from_line(cur_array[0],cur_array[-1],cur_array[b])}
    else

    end
  end

  def convert_to_lines(point_array,resolution)
    output_array= []
    point_array.each_with_index do |point,index|
      if point.type == "C"
        step = 1/resolution.to_f
        iter = 1
        while iter <= resolution
          line_point = bez_to_val(point,point_array[index-1],step*iter)
          output_array << SVGPoint.new("L",line_point)
          iter += 1
        end
      else
        output_array << point
      end
    end
    output_array
  end

  def bez_to_val(point,previous,t)

    x = previous.p.x + 3*t*(point.r1.x-previous.p.x)+3*t**2*(previous.p.x+point.r2.x-(2*point.r1.x))+t**3*(point.p.x-previous.p.x+3*point.r1.x-3*point.r2.x)
    y = previous.p.y + 3*t*(point.r1.y-previous.p.y)+3*t**2*(previous.p.y+point.r2.y-(2*point.r1.y))+t**3*(point.p.y-previous.p.y+3*point.r1.y-3*point.r2.y)
    new_point = Point.new(x,y)
    new_point

  end

  def calculate_distance(point_one,point_two)
    Math.sqrt((point_two.y-point_one.y)**2+(point_two.x-point_one.x)**2)
  end
  def convert_to_line(point_one,point_two)
    slope = (point_two.y-point_one.y).to_f/(point_two.x-point_one.x).to_f
    offset = point_one.y-(point_one.x*slope)
    {:slope=>slope,:offset=>offset}
  end
  def calculate_distance_from_line(endpoint_one,endpoint_two,inspection_point)
    line = self.convert_to_line(endpoint_one,endpoint_two)
    new_slope = -1*(1/line[:slope].to_f)
    new_offset = inspection_point.y-(inspection_point.x*new_slope)
    x_intersection = (new_offset-line[:offset]).to_f/(line[:slope]-new_slope).to_f
    y_intersection = x_intersection*new_slope + new_offset
    intersection_point = Point.new(x_intersection,y_intersection)
    calculate_distance(intersection_point,inspection_point)
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
=======
  def decurve
    @svg["svg"]["path"].each do |dist|
      dist["line_array"] = []

      dist["array_of_paths"].each do |path|
        dist["line_array"].push(convert_to_lines(path, 3))
      end
    end
  end

  def simplify(epsilon = 1)
    kind = "line_array"

    @svg["svg"]["path"].each do |dist|
      dist["simplified_lines"] = []

      if dist[kind]
      else
        kind = "array_of_paths"
      end

      dist[kind].each do |path|
        dist["simplified_lines"].push(ramer_douglas_peucker(path, epsilon))
      end
    end
  end

  def to_svg_string(kind)
    strings = Array.new()
    @svg["svg"]["path"].each do |dist|
      string = ""
      dist[kind].each do |point|
        string << point.to_s
      end

      strings << string
    end

    return strings
  end

  #private
  def ramer_douglas_peucker(pointList, epsilon)
    # Find the point with the maximum distance
    dmax = 0
    index = 0

    # If the distance is greater than epsilon, recursively simplify
    for i in 1..(pointList.length - 1)
      d = calculate_distance_from_line(pointList[0].p, pointList[-1].p, pointList[i].p)
      if d > dmax
        index = i
        dmax = d
      end
    end

    if dmax >= epsilon
      recResults1 = ramer_douglas_peucker(pointList[0..index],  epsilon)
      recResults2 = ramer_douglas_peucker(pointList[index..-1], epsilon)

      resultList = [recResults1[0..-2], recResults2[0..-1]].flatten
    else
      resultList = [pointList[0], pointList[-1]]
    end

    return resultList
  end

  def convert_to_lines(point_array, resolution)
    output_array= []
    point_array.each_with_index do |point, index|
      if point.type == "C"
        step = 1 / resolution.to_f
        iter = 1
        while iter <= resolution
          line_point = bez_to_val(point, point_array[index - 1],step * iter)
          output_array << SVGPoint.new("L", line_point)
          iter += 1
        end
      else
        output_array << point
      end
    end
    output_array
  end

  def bez_to_val(point, previous, t)
    x = previous.p.x + 3 * t * (point.r1.x - previous.p.x) + 3 * t ** 2 * (previous.p.x + point.r2.x - (2 * point.r1.x)) + t ** 3 * (point.p.x - previous.p.x + 3 * point.r1.x - 3 * point.r2.x)
    y = previous.p.y + 3 * t * (point.r1.y - previous.p.y) + 3 * t ** 2 * (previous.p.y + point.r2.y - (2 * point.r1.y)) + t ** 3 * (point.p.y - previous.p.y + 3 * point.r1.y - 3 * point.r2.y)
    new_point = Point.new(x, y)
    new_point
  end

  def calculate_distance(point_one, point_two)
    squares_added = (point_two.y - point_one.y) ** 2 + (point_two.x - point_one.x) ** 2
    distance = Math.sqrt(squares_added)

    return distance
  end

  def convert_to_line(point_one, point_two)
    slope = (point_two.y - point_one.y).to_f / (point_two.x - point_one.x).to_f
    offset = point_one.y - (point_one.x * slope)
    {:slope=>slope, :offset=>offset}
  end

  def calculate_distance_from_line(endpoint_one, endpoint_two, inspection_point)
    # Sometimes, enpoints have the same y...
    if endpoint_one.y == endpoint_two.y
      distance = (inspection_point.y - endpoint_one.y).abs
      return distance
    end

    line = self.convert_to_line(endpoint_one, endpoint_two)

    new_slope = -1 * (1 / line[:slope].to_f)
    new_offset = inspection_point.y - (inspection_point.x * new_slope)

    x_intersection = (new_offset - line[:offset]).to_f / (line[:slope] - new_slope).to_f
    y_intersection = x_intersection * new_slope + new_offset

    intersection_point = Point.new(x_intersection, y_intersection)

    calculate_distance(intersection_point, inspection_point)
  end

  def to_path_array(path)
    path.scan(/[MCL].+z/).flatten()
  end

  def to_path_point_array(path)
    path.gsub!(/(?=[^\s]|^)([A-Za-z])(?=$|[^\s])/){|q| " #{$1} "}
    path.gsub!(/  /,  ' ')
    q = path.split(/ /).reject{|q| q === ""};
    stack = []
    points = []
>>>>>>> juan/master

    q.each do |f|
      if stack.length > 0 && f =~ /[MCLSz]/
        points << to_svg(stack)
        stack = []
      end
      stack << f
    end

    points
<<<<<<< HEAD

  end

  def to_svg(stack)

    if stack[0] == "C"
      a = SVGPoint.new(stack[0],Point.new(stack[3]),Point.new(stack[1]),Point.new(stack[2]))
    else
      a = SVGPoint.new(stack[0],Point.new(stack[1]))
=======
  end

  def to_svg(stack)
    if stack[0] == "C"
      a = SVGPoint.new(stack[0], Point.new(stack[3]), Point.new(stack[1]), Point.new(stack[2]))
    else
      a = SVGPoint.new(stack[0], Point.new(stack[1]))
>>>>>>> juan/master
    end
  end

  end

end

# vim:set et sw=2 ts=2:
