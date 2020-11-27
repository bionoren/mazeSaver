//
//  grid.m
//  mazes
//
//  Created by Bion Oren on 11/3/20.
//

#import "grid.h"

@interface Grid ()

@property (nonatomic, retain) NSMutableArray<NSMutableArray<Cell*>*>* cells;

@end

@implementation Grid

@synthesize cells;

-(id)initWithRows:(int)rows Columns:(int)columns {
   if ((self = [super init])) {
      self.cells = [[NSMutableArray alloc] initWithCapacity:rows];
      int index = 0;
      for(int r = 0; r < rows; r++) {
         NSMutableArray *col = [[NSMutableArray alloc] initWithCapacity:columns];
         for(int c = 0; c < columns; c++) {
            Cell *cell = [[Cell alloc] init];
            cell.index = index++;
            cell.row = r;
            cell.column = c;
            
            [col addObject:cell];
         }
         [self.cells addObject:col];
      }

      for(int r = 0; r < rows; r++) {
         for(int c = 0; c < columns; c++) {
            Cell *cell = [self cellForRow:r Column:c];
            if(r > 0) {
               Cell *neighbor = [self cellForRow:r-1 Column:c];
               [cell addNeighbor:neighbor InDirection:NORTH];
            }
            if(r+1 < rows) {
               Cell *neighbor = [self cellForRow:r+1 Column:c];
               [cell addNeighbor:neighbor InDirection:SOUTH];
            }
            if(c > 0) {
               Cell *neighbor = [self cellForRow:r Column:c-1];
               [cell addNeighbor:neighbor InDirection:WEST];
            }
            if(c+1 < columns) {
               Cell *neighbor = [self cellForRow:r Column:c+1];
               [cell addNeighbor:neighbor InDirection:EAST];
            }
         }
      }
   }

   return self;
}

-(int)rows {
    return (int)self.cells.count;
}

-(int)columns {
    return (int)self.cells[0].count;
}

-(int)size {
    return self.rows * self.columns;
}

-(Cell*)cellForRow:(int)row Column:(int)column {
   return [[self.cells objectAtIndex:row] objectAtIndex:column];
}

-(Cell*)cellForIndex:(int)index {
    int row = index / self.columns;
    int col = index % self.columns;
    return [self cellForRow:row Column:col];
}

-(Cell*)start {
    return [self cellForRow:self.rows-1 Column:0];
}

-(Cell*)end {
    return [self cellForRow:0 Column:self.columns-1];
}

@end
