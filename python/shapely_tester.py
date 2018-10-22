from shapely.geometry import Point


c1 = Point(0,0).buffer(1)
c2 = Point(3,0).buffer(1)
c3 = Point(1.5,0).buffer(3)


p = Point(2,0)
print c1.distance(p)