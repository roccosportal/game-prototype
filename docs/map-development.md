#layers

##dynamic
  Contains dynamic rectangles. The name have to be ```dynamic```. The rectangles you place will be dynamic objects. Set ```resetSavePoint``` to the save point id, when this dynamic object should be reset when the player respawns at a certain save point.

##savePoints
  Contains the save point areas. The name have to be ```savePoints```. Each rectangle represents a save point. When the player pass through such a save point, the player will respawn after death in the middle of the save point. Set the customProperty ```id``` to assign an identifier. The player will start at the first save point or the one that has the customProperty ```isStart``` set to ```true```.
  
##killAreas
  Contains areas where the player dies when he enters. The name have to be ```killAreas```. Each rectangle represents a kill area. If the customProperty ```isCollidable``` is not set or set to ```true``` other objects can collide with the area.

##ropes
  Each layer represents a single rope. The layer name have to start with ```rope``` to be recognized as a rope. A circle represents a part of the rope. The order of the circles are important. The first circle marks the starting point of the rope and is static. The rope looks more realistic when a lot of circles are used which are close to each other.
  
  
##coilSprings
  Contains coil springs. The name have to be ```coilSprings```. Each rectangle represents a coil spring. The bottom left corner of the rectangle is the bottom left corner of the coil spring. The size of the rectangle does not matter.
