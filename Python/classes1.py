
# [self] is like the implicit parameter [this] of C++/Java, except this time is EXPLICIT


#Beware: All attributes are PUBLIC by default! 

class Point:
    
    #static variable(s):
    originX = 0
    originY = 0
    
    def __init__(self, x, y):
        self.x = x
        self.y = y
        
        """
            Operation to move a point
            IN: Coordinates DX, DY
            OUT: Coordinates (x+DX, y+DY)
        """
    def move(self, dx, dy):
        self.x += dx
        self.y += dy
        
    #private
    def _swap(self, x, y):
        auX = self.x
        self.x = self.y
        self.y = auX
        
    def write(self):
        print(self.x, self.y)
        
    
    """ 
        print operation for point
    """
    def __repr__(self):
        return "Point (" + str(self.x) + ", " + str(self.y) + ")\n"
        
# Inheritance
class PointCol:
    def __init__(self, x, y, col):
        self.x = x
        self.y = y
        self.col = col
        
pt = Point(3, 6)

pt.write()
pt.move(2, 2)
pt.write()

# If attributes are public...
pt.x = 5
pt.write()
print(pt)
