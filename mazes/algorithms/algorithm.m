//
//  algorithm.m
//  mazes
//
//  Created by Bion Oren on 11/27/20.
//

#import "algorithm.h"

enum Directions randomDirection(struct randomDirections* dirs) {
    int idx = arc4random_uniform(dirs->size);
    enum Directions dir = dirs->directions[idx];

    dirs->size--;
    dirs->directions[idx] = dirs->directions[dirs->size];

    return dir;
}

void resetRandomDirections(struct randomDirections* dirs) {
    for(enum Directions d = NORTH; d <= WEST; d++) {
        dirs->directions[d] = d;
    }
    dirs->size = WEST+1;
}
