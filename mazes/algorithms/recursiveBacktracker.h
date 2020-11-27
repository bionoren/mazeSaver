//
//  recursiveBacktracker.h
//  mazes
//
//  Created by Bion Oren on 11/27/20.
//

#import <Foundation/Foundation.h>
#import "grid.h"
#import "algorithm.h"

@interface RecursiveBacktracker : NSObject <Algorithm>

-(id)initWithGrid:(Grid*)grid;
-(bool)step; // explores a new cell in the maze

@end
