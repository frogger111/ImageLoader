//
//  TPCache.m
//  ImageLoader
//
//  Created by Tobiasz Parys on 12/03/14.
//
//

#import "TPCache.h"

@implementation TPCache

+(instancetype)shareCache{

    static TPCache *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(void)clearAllCache{

    [self removeAllObjects];
}


@end
