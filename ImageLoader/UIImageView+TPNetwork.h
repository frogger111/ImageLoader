//
//  UIImageView+TPNetwork.h
//  ImageLoader
//
//  Created by Tobiasz Parys on 05/03/14.
//
//

#import <UIKit/UIKit.h>


@interface UIImageView (TPNetwork)

- (void)setImageWithURL:(NSURL *)url;


- (void)cancelAllOperations;

@end
