//
//  CityDic.m
//  CityTableView
//
//  Created by apple on 15/4/10.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "CityDic.h"
#import "pinyin.h"

@interface CityDic()

@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSDictionary *cityByProvinceDic;
@property (nonatomic, strong) NSDictionary *cityByWordDic;
@property (nonatomic, strong) NSDictionary *cityPyNemeDic;

@end

@implementation CityDic

static CityDic *cityDic = nil;
static dispatch_once_t predicate;

+ (NSArray *)allProvince{
    dispatch_once(&predicate, ^{
        cityDic = [[CityDic alloc] init];
    });
    return cityDic.provinceArray;
}

+ (NSArray *)allCity{
    dispatch_once(&predicate, ^{
        cityDic = [[CityDic alloc] init];
    });
    return cityDic.cityArray;
}

+ (NSDictionary *)allCityByProvince{
    dispatch_once(&predicate, ^{
        cityDic = [[CityDic alloc] init];
    });
    return cityDic.cityByProvinceDic;
}

+ (NSDictionary *)allCityByWordDic{
    dispatch_once(&predicate, ^{
        cityDic = [[CityDic alloc] init];
    });
    return cityDic.cityByWordDic;
}

+ (NSDictionary *)allCityPyNemeDic{
    dispatch_once(&predicate, ^{
        cityDic = [[CityDic alloc] init];
    });
    return cityDic.cityPyNemeDic;
}

+ (NSArray *)selectCity:(NSString *)name{
    dispatch_once(&predicate, ^{
        cityDic = [[CityDic alloc] init];
    });
    return [cityDic selectCity:name];
}

- (instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData{
    //获得plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //所有省份
    [self setProvinceArray:[dic allKeys]];
    
    //所有城市 按 省份 分组
    [self setCityByProvinceDic:dic];
    
    //所有城市
    NSMutableArray *cityArray = [NSMutableArray array];
    NSArray *vArray = [dic allValues];
    for (NSInteger i = 0; i < vArray.count; i++) {
        [cityArray addObjectsFromArray:vArray[i]];
    }
    [self setCityArray:cityArray];
    
    //所有城市 按照 首字母 分组
    NSMutableDictionary *cityByWordDic = [NSMutableDictionary dictionary];
    //城市 拼音首字母 字典
    NSMutableDictionary *cityPyNameDic = [NSMutableDictionary dictionary];
    //城市名-名字拼音 按 首字母 排序
    
    for (NSInteger i = 0; i < cityArray.count; i++) {
        //所有城市 按照 首字母 分组
        NSString *word = [NSString stringWithFormat:@"%c",pinyinFirstLetter([cityArray[i] characterAtIndex:0])];
        if (cityByWordDic[word]) {
            [cityByWordDic[word] addObject:cityArray[i]];
        }else{
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObject:cityArray[i]];
            [cityByWordDic setObject:temp forKey:word];
        }
        //城市 拼音首字母 字典
        NSString *cityPy = [self pyName:cityArray[i]];
        if (cityPyNameDic[cityPy]) {
            [cityPyNameDic[cityPy] addObject:cityArray[i]];
        }else{
            NSMutableArray *tempCity = [NSMutableArray array];
            [tempCity addObject:cityArray[i]];
            [cityPyNameDic setObject:tempCity forKey:cityPy];
        }
    }
    //所有城市 按照 首字母 分组
    [self setCityByWordDic:cityByWordDic];
    //城市 拼音首字母 字典
    [self setCityPyNemeDic:cityPyNameDic];
    //城市名-名字拼音 按 首字母 排序
    
}

- (NSString *)pyName:(NSString *)name{
    NSString *str = @"";
    for (NSInteger i = 0; i < [name length]; i++){
        str = [NSString stringWithFormat:@"%@%c",str,pinyinFirstLetter([name characterAtIndex:i])];
    }
    return str;
}

- (NSString *)firstPyName:(NSString *)name{
    NSString *str = [NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])];
    return str;
}

- (NSArray *)selectCity:(NSString *)name{
    NSString *py = [[self pyName:name] lowercaseString];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *equql;
    
    for (NSString *city in [_cityPyNemeDic allKeys]) {
        //比较拼音缩写
        NSRange range = [city rangeOfString:py];
        if (range.length > 0) {
            //比较拼音缩写两个是否相等
//            if ([city isEqualToString:py]) {
//                for (NSString *str in _cityPyNemeDic[city]) {
//                    if ([name isEqualToString:str]) {
//                        return @[name];
//                    }
//                }
//                return _cityPyNemeDic[city];
//            }else{
//                for (NSString *s in _cityPyNemeDic[city]) {
//                    NSRange aRange = [s rangeOfString:name];
//                    if (aRange.length > 0) {
//                        [tempArray addObject:s];
//                    }
//                }
//            }

            for (NSString *str in _cityPyNemeDic[city]) {
                if ([city isEqualToString:py]) {
                    if ([name isEqualToString:str]) {
                        return @[name];
                    }
                    equql = _cityPyNemeDic[city];
                }
                NSRange aRange = [str rangeOfString:name];
                if (aRange.length > 0) {
                    [tempArray addObject:str];
                }
            }
        }
    }
    
    return tempArray.count > equql.count ? tempArray : equql;
}

@end
