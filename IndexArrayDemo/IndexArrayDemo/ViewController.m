//
//  ViewController.m
//  IndexArrayDemo
//
//  Created by LamTsanFeng on 2017/10/20.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "ViewController.h"

#import "Dog.h"
#import "Cat.h"
#import "Fish.h"

#import "IndexArray.h"

@interface ViewController ()

@property (nonatomic, strong) IndexArray *indexArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#warning Array contains different kinds of objects, the index values can not be the same.
    self.indexArray = [IndexArray new];
    
    NSArray *names = @[@"Oliver", @"Harry", @"Kate", @"Charlotter", @"George", @"Alice", @"Gracie", @"Jenson", @"Ezra", @"Stanley"];
    
    /** Test dog */
    for (NSInteger i=0; i<10; i++) {
        Dog *d = [Dog new];
        d.aId = [NSString stringWithFormat:@"%d", (int)i];
        d.name = names[(arc4random() % 10)];
        [self.indexArray addObject:d];
    }
    
    /** Test cat */
    for (NSInteger i=10; i<20; i++) {
        Cat *c = [Cat new];
        c.card = [NSString stringWithFormat:@"%d", (int)i];
        c.name = names[(arc4random() % 10)];
        [self.indexArray addObject:c];
    }
    
    /** Test fish */
    for (NSInteger i=20; i<30; i++) {
        Fish *f = [Fish new];
        f.fId = [NSString stringWithFormat:@"%d", (int)i];
        f.name = names[(arc4random() % 10)];
        [self.indexArray insertObject:f atIndex:0];
    }
    
    
    NSLog(@"%@", self.indexArray);
    
    /** Get objects at index */
    NSLog(@"Get objects at index : %@", [self.indexArray objectAtIndex:5]);
    NSLog(@"Get objects at index : %@", [self.indexArray objectAtIndex:15]);
    
    /** Get objects at key */
    NSLog(@"Get objects at key : %@", [self.indexArray objectForKey:@"5"]);
    NSLog(@"Get objects at key : %@", [self.indexArray objectForKey:@"15"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
