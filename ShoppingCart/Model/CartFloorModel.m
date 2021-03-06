//
//  CartFloorModel.m
//  ShoppingCart
//
//  Created by guochaoyang on 16/1/12.
//  Copyright © 2016年 ccguo. All rights reserved.
//

#import "CartFloorModel.h"

@implementation CartFloorModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _list = [NSMutableArray array];
        [self setWithDic:dic];
    }
    return self;
}

- (void)setWithDic:(NSDictionary *)dic
{
    NSDictionary *headerDic = JSON_PARSE(dic[@"head"], [NSDictionary class]);
    NSArray *skuList = JSON_PARSE(dic[@"skuList"], [NSArray class]);
    _headerModel = [[CartHeaderModel alloc] initWithDic:headerDic];
    for (NSDictionary *dic in skuList) {
        @autoreleasepool
        {
            CartSkuModel * model = [[CartSkuModel alloc] initWithDic:dic];
            [_list addObject:model];
        }
    }
}

#pragma mark - CartFloorProtocol
- (NSInteger)numberOfModelInFloor
{
    NSInteger row = 0;
    if (self.list.count) row += self.list.count;
    
    return row;
}

- (id<CartRenderProtocol>)modelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    if (index < [self numberOfModelInFloor]) {
        return self.list[index];
    }
    return nil;
}

- (id<CartRenderProtocol>)modelForHeaderAtIndexPath:(NSInteger)index
{
    if (self.headerModel && index == 0) {
        return self.headerModel;
    }
    return nil;
}

#pragma mark - API

- (NSInteger)count
{
    return self.list.count;
}

- (void)removeObjectAtIndexPath:(NSInteger)index
{
    if (index > 0 && index < self.list.count) {
        [self.list removeObjectAtIndex:index];
    }
}
@end
