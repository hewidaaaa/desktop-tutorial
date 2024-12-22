class Bird:
    def move(self):
        pass

class FlyingBird(Bird):
    def move(self):
        print("Flying")

class NonFlyingBird(Bird):
    def move(self):
        print("Walking")

class Sparrow(FlyingBird):
    def move(self):
        print("Sparrow is flying")

class Penguin(NonFlyingBird):
    def move(self):
        print("Penguin is walking")

sparrow = Sparrow()
penguin = Penguin()

sparrow.move() 
penguin.move()  
