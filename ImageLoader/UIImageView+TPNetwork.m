//
//  UIImageView+TPNetwork.m
//  ImageLoader
//
//  Created by Tobiasz Parys on 05/03/14.
//
//

#import "UIImageView+TPNetwork.h"
#import "TPRequestOperation.h"
#import "TPCache.h"

#import <objc/runtime.h>

@interface UIImageView (_TPNetwork)

//@property (nonatomic, strong) TPRequestOperation *tpRequestOperation;
@property (readwrite, nonatomic, strong, setter = tp_setImageRequestOperation:) TPRequestOperation *tpRequestOperation;

@end

@implementation UIImageView (TPNetwork)

+ (NSOperationQueue *)tp_sharedImageRequestOperationQueue {
    static NSOperationQueue *_tp_sharedImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tp_sharedImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        _tp_sharedImageRequestOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    });
    
    return _tp_sharedImageRequestOperationQueue;
}

- (TPRequestOperation *)tp_imageRequestOperation {
    return (TPRequestOperation *)objc_getAssociatedObject(self, @selector(tpRequestOperation));
}

- (void)tp_setImageRequestOperation:(TPRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, @selector(tpRequestOperation), imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setImageWithURL:(NSURL *)url{

    [self setImageWithURL:url success:nil failure:nil];
    
}

- (void)setImageWithURL:(NSURL *)url success:(void (^)(NSURL *url, id response))success failure:(void (^)(NSURL *url, NSError *error))failure {

    [self cancelAllOperations];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake((self.bounds.size.width  - indicator.frame.size.width) / 2, (self.bounds.size.height - indicator.frame.size.height) / 2, indicator.bounds.size.width, indicator.bounds.size.height);
    
    [indicator startAnimating];
    
    indicator.hidesWhenStopped = YES;
    [self addSubview:indicator];
    
    UIImage *imageCached = [[TPCache shareCache] objectForKey:url];
    
    if(imageCached){
    
        if(success){
        
            success(nil, imageCached);
        } else {
        
            self.image = imageCached;
        }
        
        self.tpRequestOperation = nil;
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    } else {
    
        __weak __typeof(self)weakSelf = self;
        self.tpRequestOperation = [[TPRequestOperation alloc] initWithURL:url];
        [self.tp_imageRequestOperation setComletitionBlockWithSuccess:^(TPRequestOperation *op, id responseObject) {
            
            if([url isEqual:op.url]){
            
                if(success){
                
                    success(url, responseObject);
                }  else if (responseObject) {
                    
                    __weak __typeof(self)strongSelf = weakSelf;
                    strongSelf.image = responseObject;
                }
                
                [indicator stopAnimating];
                [indicator removeFromSuperview];
            }
        } failure:^(TPRequestOperation *op, NSError *error) {
            if ([url isEqual:op.url]) {
                if (failure) {
                    failure(url, error);
                }
                
                [indicator stopAnimating];
                [indicator removeFromSuperview];
            }
            
            
        }];
        
        [[[self class] tp_sharedImageRequestOperationQueue] addOperation:self.tp_imageRequestOperation];
    }
    
    
}

- (void)cancelAllOperations{

        [self.tp_imageRequestOperation cancel];
        self.tpRequestOperation = nil;
}

@end
