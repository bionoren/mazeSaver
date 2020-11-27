//
//  huntAndKill.m
//  mazes
//
//  Created by Bion Oren on 11/26/20.
//

#import <stdlib.h>
#import "huntAndKill.h"
#import "cell.h"

// implements the HuntAndKill algorithm
@interface HuntAndKill () {
    struct randomDirections _dirOptions;
}

@property (nonatomic, retain) Grid *grid;
@property (nonatomic, retain) Cell *node;
@property (nonatomic, assign) int visits;

@end

@implementation HuntAndKill

@synthesize grid;
@synthesize node;
@synthesize visits;

-(id)initWithGrid:(Grid*)grid {
   if ((self = [super init])) {
       self.grid = grid;

       int index = arc4random_uniform(self.grid.size);
       self.node = [self.grid cellForIndex:index];
       self.node.explored = true;
       self.visits = 1;
       resetRandomDirections(&_dirOptions);
   }

   return self;
}

-(bool)step {
    if(self.visits == self.grid.size) {
        return true;
    }

    while(_dirOptions.size > 0) {
        enum Directions dir = randomDirection(&_dirOptions);
        Cell* next = [self.node NeighborInDirection:dir];
        if(next == nil || next.explored) {
            continue;
        }

        next.explored = true;
        self.visits++;
        self.node = [self.node connect:dir];
        resetRandomDirections(&_dirOptions);

        return false;
    }

    for(int r = 0; r < self.grid.rows; r++) {
        for(int c = 0; c < self.grid.columns; c++) {
            Cell* node = [self.grid cellForRow:r Column:c];
            if(node.explored) {
                continue;
            }

            enum Directions options[WEST+1];
            int numOptions = 0;
            for(enum Directions d = NORTH; d <= WEST; d++) {
                Cell* n = [node NeighborInDirection:d];
                if(n != nil && n.explored) {
                    options[numOptions++] = d;
                }
            }

            if(numOptions > 0) {
                enum Directions direction = options[arc4random_uniform(numOptions)];

                [node connect:direction];
                self.node = node;
                node.explored = true;
                self.visits++;

                resetRandomDirections(&_dirOptions);
                return false;
            }
        }
    }

    return true;
}

@end
