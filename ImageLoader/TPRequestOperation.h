//
//  TPRequestOperation.h
//  ImageLoader
//
//  Created by Tobiasz Parys on 12/03/14.
//
//

#import <Foundation/Foundation.h>

@interface TPRequestOperation : NSOperation

@property (nonatomic, readonly, strong) id responseObject;
@property (nonatomic, readonly, strong) NSError *error;
@property (nonatomic, readonly, strong) NSURL *url;

-(id)initWithURL:(NSURL *)url;

-(void)setComletitionBlockWithSuccess:(void (^)(TPRequestOperation *op, id responseObject))success
                              failure:(void (^)(TPRequestOperation *op, NSError *error))failure;


@end
