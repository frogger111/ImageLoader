//
//  TPRequestOperation.m
//  ImageLoader
//
//  Created by Tobiasz Parys on 12/03/14.
//
//

#import "TPRequestOperation.h"
#import "TPCache.h"

@interface TPRequestOperation()

@property (nonatomic, readwrite, strong) id responseObject;
@property (nonatomic, readwrite, strong) NSError *error;
@property (nonatomic, readwrite, strong) NSURL *url;

@end

@implementation TPRequestOperation;

-(id)initWithURL:(NSURL *)url{

    if(self = [super init]){
    
        self.url = url;
    }
    
    return self;
}

-(void)main{

    @autoreleasepool {
        
        if(self.isCancelled){
        
            self.error = [NSError errorWithDomain:@"Canceled" code:-1 userInfo:nil];
            return;
        }
        
        self.responseObject = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:self.url]];
        
        if(self.responseObject){
        
            [[TPCache shareCache] setObject:self.responseObject forKey:self.url];
        } else {
        
            self.error = [NSError errorWithDomain:@"Error" code:-2 userInfo:nil];
        }
    }
}

-(void)setComletitionBlockWithSuccess:(void (^)(TPRequestOperation *op, id responseObject))success failure:(void (^)(TPRequestOperation *op, NSError *error))failure{

    __weak typeof(self) weakSelf = self;
    
    [self setCompletionBlock:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(weakSelf.error){
        
            if(failure){
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(strongSelf, strongSelf.error);
                });
            }
        } else {
            
            id responseObject = weakSelf.responseObject;
            
            if(weakSelf.error || !responseObject){
        
                if(failure){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        failure(strongSelf, strongSelf.error);
                    });
                }
                
            } else {
            
                if(success){
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        success(strongSelf, responseObject);
                    });
                }
            }
        }
        
    }];
}

@end
