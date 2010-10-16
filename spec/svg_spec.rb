 $LOAD_PATH.unshift( File.join( File.dirname(__FILE__),'..', 'src' ) )
require 'svg'

describe SVG,"svg function" do

    it "measures the distance between two points" do
        a=SVG.new("")
        p1 = Point.new(1,1)
        p2 = Point.new(4,7)
        distance = a.calculate_distance(p1,p2)
        distance.should eql(Math.sqrt(45))
    end

    it "converts an svg string into svg object" do
        a = SVG.new("M0,0 L 0,5 C 0,0 10,10 5,0 L0,0 z")
        a.convert
        a.svg["svg"]["path"][0]["array_of_paths"][0].length.should eql(4)
        a.svg["svg"]["path"][0]["array_of_paths"][0][2].type.should eql("C")
        a.svg["svg"]["path"][0]["array_of_paths"][0][2].p.x.should eql(5.0)
    end
    it "converts all curves to lines" do
        a = SVG.new("M0,0 L 0,5 C 0,0 10,10 5,0 L0,0 z")
        a.convert
        a.decurve
        puts a.svg["svg"]["path"][0]["line_array"][0].inspect 
        a.svg["svg"]["path"][0]["line_array"][0].length.should eql(6)
    end
end

