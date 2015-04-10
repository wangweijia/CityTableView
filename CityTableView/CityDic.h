//
//  CityDic.h
//  CityTableView
//
//  Created by apple on 15/4/10.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDic : NSObject

/**
 *  所有省份
 *
 *  @return 数组（省份名）
 */
+ (NSArray *)allProvince;

/**
 *  所有城市
 *
 *  @return 数组（城市名）
 */
+ (NSArray *)allCity;

/**
 *  所有城市按省份分组
 *
 *  @return 字典（key：省份，value：城市数组）
 */
+ (NSDictionary *)allCityByProvince;

/**
 *  所有城市按首字母分组
 *
 *  @return 字典（key：首字母(小写)，value：城市数组）
 */
+ (NSDictionary *)allCityByWordDic;

/**
 *  所有城市 对应 拼音首字母缩写
 *
 *  @return 字典（key：拼音首字母，value：城市数组）
 */
+ (NSDictionary *)allCityPyNemeDic;

/**
 *  查询城市(拼音首字母、城市名部分字)
 *
 *  @param name 城市名
 *
 *  @return 城市数组
 */
+ (NSArray *)selectCity:(NSString *)name;

@end
