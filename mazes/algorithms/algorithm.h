//
//  algorithm.h
//  mazes
//
//  Created by Bion Oren on 11/27/20.
//

#import <Foundation/Foundation.h>
#import "cell.h"

@protocol Algorithm <NSObject>

-(Cell*)step; // explores a new cell in the maze

@end

struct randomDirections {
    enum Directions directions[WEST+1];
    int size;
};

enum Directions randomDirection(struct randomDirections* dirs);
void resetRandomDirections(struct randomDirections* dirs);
