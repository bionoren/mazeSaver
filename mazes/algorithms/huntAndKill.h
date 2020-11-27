//
//  huntAndKill.h
//  mazes
//
//  Created by Bion Oren on 11/26/20.
//

#import <Foundation/Foundation.h>
#import "grid.h"
#import "algorithm.h"

@interface HuntAndKill : NSObject <Algorithm>

-(id)initWithGrid:(Grid*)grid;
-(bool)step; // explores a new cell in the maze

@end
