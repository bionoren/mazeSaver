//
//  cell.m
//  mazes
//
//  Created by Bion Oren on 11/3/20.
//

#import "cell.h"

@interface Cell () {
    Cell* _neighbors[WEST+1];
    bool _openings[WEST+1];
}

@end

@implementation Cell

@synthesize index;
@synthesize row;
@synthesize column;
@synthesize explored;

-(id)init {
    if ((self = [super init])) {
        for(enum Directions d = NORTH; d <= WEST; d++) {
            _openings[d] = false;
            _neighbors[d] = nil;
        }
    }

    return self;
}

-(void)addNeighbor:(Cell*)neighbor InDirection:(enum Directions)direction {
    _neighbors[direction] = neighbor;
}

-(Cell*)NeighborInDirection:(enum Directions)direction {
    return _neighbors[direction];
}

-(bool)HasNeighborInDirection:(enum Directions)direction {
    return _neighbors[direction] != nil;
}

-(Cell*)connect:(enum Directions)direction {
    _openings[direction] = true;
    Cell* neighbor = _neighbors[direction];
    [neighbor connectInternal:REVERSE_DIR(direction)];

    return neighbor;
}

-(void)connectInternal:(enum Directions)direction {
    _openings[direction] = true;
}

-(void)disconnect:(enum Directions)direction {
    _openings[direction] = false;
    Cell* neighbor = _neighbors[direction];
    [neighbor disconnectInternal:REVERSE_DIR(direction)];
}

-(void)disconnectInternal:(enum Directions)direction {
    _openings[direction] = false;
}

-(bool)connected:(enum Directions)direction {
    return _openings[direction];
}

@end

enum Directions REVERSE_DIR(enum Directions d) {
    switch(d) {
        case NORTH:
            return SOUTH;
        case EAST:
            return WEST;
        case SOUTH:
            return NORTH;
        case WEST:
            return EAST;
    }
}
