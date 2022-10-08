//
//  UserModel.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import "UserModel.h"
#import <MJExtension/MJExtension.h>

@implementation WeightDataModel

@end

@implementation UserModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"weights" : WeightDataModel.class
              };
}

@end
