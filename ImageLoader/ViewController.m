//
//  ViewController.m
//  ImageLoader
//
//  Created by Tobiasz Parys on 05/03/14.
//
//

#import "ViewController.h"
#import "UIImageView+TPNetwork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.imageView setImageWithURL:[NSURL URLWithString:@"http://cdn.dice.com/wp-content/uploads/2011/05/apple-logo.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
