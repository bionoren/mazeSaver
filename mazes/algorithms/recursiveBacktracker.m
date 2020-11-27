//
//  recursiveBacktracker.m
//  mazes
//
//  Created by Bion Oren on 11/27/20.
//

#import <stdlib.h>
#import "recursiveBacktracker.h"
#import "cell.h"

// implements the RecursiveBacktracker algorithm
@interface RecursiveBacktracker () {
    struct randomDirections _dirOptions;
}

@property (nonatomic, retain) Grid *grid;
@property (nonatomic, retain) NSMutableArray<Cell*>* stack;

@end

@implementation RecursiveBacktracker

@synthesize grid;
@synthesize stack;

-(id)initWithGrid:(Grid*)grid {
    if ((self = [super init])) {
        self.grid = grid;

        int index = arc4random_uniform(self.grid.size);
        Cell* node = [self.grid cellForIndex:index];
        node.explored = true;
        self.stack = [[NSMutableArray alloc] initWithCapacity:self.grid.size / 2];
        [self.stack addObject:node];
    }

    return self;
}

-(bool)step {
    while(self.stack.count > 0) {
        Cell* node = self.stack.lastObject;

        resetRandomDirections(&_dirOptions);
        while(_dirOptions.size > 0) {
            enum Directions d = randomDirection(&_dirOptions);
            if(![node HasNeighborInDirection:d]) {
                continue;
            }
            Cell* next = [node NeighborInDirection:d];
            if(!next.explored) {
                next = [node connect:d];
                next.explored = true;
                [self.stack addObject:next];

                return false;
            }
        }

        [self.stack removeLastObject];
    }

    return true;
}

@end

/*
 size := g.Rows() * g.Cols()
 node := g.CellForIndex(rand.Intn(size))
 visited := make([]bool, size)
 visited[node.Index()] = true

 directions := make([]grid.Direction, (grid.WEST+1)*2)
 for d := grid.NORTH; d <= grid.WEST; d++ {
     directions[d] = d
 }
 dirOptions := directions[grid.WEST+1:]
 directions = directions[:grid.WEST+1]

 stack := make([]grid.Cell, 1, g.Cols()*g.Rows()/2)
 stack[0] = node
 for len(stack) > 0 {
     // fmt.Printf("stack size: %d, dirOptions size: %d\n", len(stack), len(dirOptions))
     if len(dirOptions) > 0 {
         i := grid.Direction(rand.Intn(len(dirOptions)))
         dir := dirOptions[i]
         if next := node.Neighbor(dir); next != nil && !visited[next.Index()] {
             visited[next.Index()] = true
             g.Connect(node.Row(), node.Col(), dir)

             node = *next
             dirOptions = dirOptions[:cap(dirOptions)]
             copy(dirOptions, directions)
             stack = append(stack, node)
         } else { // this random direction is already visited, remove it from the current option list
             dirOptions[i] = dirOptions[len(dirOptions)-1]
             dirOptions = dirOptions[:len(dirOptions)-1]
         }
     } else { // backtrack
         node = stack[len(stack)-1]
         stack = stack[:len(stack)-1]

         dirOptions = dirOptions[:cap(dirOptions)]
         copy(dirOptions, directions)
     }
 }
 */
