# saga
A game I would enjoy playing

## TODOs:
1. Entities should switch the direction they face before they move not after
2. Fix function and or property naming in Statistics
3. I represent and reference textures in several slightly different ways, I wonder which method is the best. What would it mean to cache them? `SelectionType` can reference them by its value that seems fairly useful.
4. Generalize InterfaceElements to nest as deep as I want. Probably not necessary but who cares
5. Make fill actions undoable
6. Add new file dialogue to name new images
7. Need to distinguish different types of moves, eg. walked pushed teleported etc
8. Figure out what happens when an entity dies
9. When the turns are cycling quickly sometimes it will remove an entity while we are highlighting the correct entity, thereby unselecting it
10. Add comments for all types
11. Theres a better way to do entity position and sprite position, having them seperate has been causing issues
12. If I want objects to block projectiles Im going to need to figure out a more robust system, especially since not all projectiles go on straight paths.
13. Related to 12, UI to indicate hit chance
14. Building the grid graph takes a long ass time, I wonder if it would be more efficient to build it as the map is being built
15. There are some quality of use improvements that could be made to object definitions, it would be nice if they each defined their own probability and didnt need to base it in relation to the others
16. Remove prefixes from the rest of the assets
17. Im seeing a little bit of lag now when using abilities with animations (especially voidball)

## Features:
1. Autoexplore
2. Better dungeon generation
3. Unique weapons by composition
4. Name weapons to make them your own (canonize)

## Ideas:
1. Going out of bounds (> 1.0) with a UIColor produces strange and colorful results

## Remarks:
1. SKTileMapNodes seem to have trouble with being deallocated. For now I simply reuse the SKTileMapNodes I have. Im not sure if this will be an issue in the future.
