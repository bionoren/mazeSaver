//
//  solver.m
//  mazes
//
//  Created by Bion Oren on 11/27/20.
//

#import "solver.h"
#import "algorithms/algorithm.h"

@interface Solver () {
    bool* _visited;
}

@property (nonatomic, retain) Grid* grid;
@property (nonatomic, retain) NSMutableArray<Cell*>* path;
@property (nonatomic, retain) Cell* current;

@end

@implementation Solver

@synthesize grid;

-(id)initWithGrid:(Grid*)grid {
    if(self = [super init]) {
        self.grid = grid;
        self.path = [[NSMutableArray alloc] initWithCapacity:self.grid.size / 2];
        _visited = calloc(self.grid.size, sizeof(bool));

        [self visitCell:self.grid.start];
    }

    return self;
}

-(void)dealloc {
    free(_visited);
}

-(NSArray<Cell*>*)Path {
    return self.path;
}

-(Cell*)step {
    if(self.current == [self.grid end]) {
        return nil;
    }

    struct randomDirections dirOptions;
    resetRandomDirections(&dirOptions);
    while(dirOptions.size > 0) {
        enum Directions d = randomDirection(&dirOptions);
        if([self.current connected:d]) {
            Cell* node = [self.current NeighborInDirection:d];
            if(!_visited[node.index]) {
                [self visitCell:node];
                return node;
            }
        }
    }

    Cell* node = self.path.lastObject;
    [self.path removeLastObject];
    self.current = self.path.lastObject;

    return node;
}

-(void)visitCell:(Cell*)node {
    self.current = node;
    [self.path addObject:node];
    _visited[node.index] = true;
}

@end
