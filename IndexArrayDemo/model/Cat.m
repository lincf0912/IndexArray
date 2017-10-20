//
//  Cat.m
//  IndexArrayDemo
//
//  Created by LamTsanFeng on 2017/10/20.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "Cat.h"

@implementation Cat

- (NSString *)description
{
    return [NSString stringWithFormat:@"Cat id:%@ name:%@", self.card, self.name];
}

@end
