//
//  cell.h
//  mazes
//
//  Created by Bion Oren on 11/3/20.
//

#import <Foundation/Foundation.h>

enum Directions {
   NORTH,
   EAST,
   SOUTH,
   WEST,
};

enum Directions REVERSE_DIR(enum Directions d);

@interface Cell : NSObject

@property (assign) int index;
@property (assign) int row;
@property (assign) int column;
@property (assign) bool explored;

-(void)addNeighbor:(Cell*)neighbor InDirection:(enum Directions)direction;
-(Cell*)NeighborInDirection:(enum Directions)direction;
-(bool)HasNeighborInDirection:(enum Directions)direction;
-(Cell*)connect:(enum Directions)direction;
-(void)disconnect:(enum Directions)direction;
-(bool)connected:(enum Directions)direction;

@end
