//
//  CitysDBToDictUtils.m
//  AllFree
//
//  Created by Houyushen on 15/4/11.
//  Copyright (c) 2015年 Houyushen. All rights reserved.
//

#import "CitysDBToDictUtils.h"
#import "pinyin.h"
#import "FMDB.h"

#define CitysTableName @"city"

@implementation CitysDBToDictUtils

+ (NSMutableArray *)cityDictFromDB
{
    NSString *cityDbPath = [[NSBundle mainBundle] pathForResource:@"ddf_cities" ofType:@"db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:cityDbPath];
    NSMutableArray *citys = [[NSMutableArray alloc] init];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"select * from %@", CitysTableName]];
        while ([resultSet next]) {
            if ([resultSet stringForColumnIndex:0] != nil) {
                NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                [cityDict setObject:[NSNumber numberWithInteger:[resultSet intForColumn:@"id"]] forKey:@"id"];
                [cityDict setObject:[resultSet stringForColumn:@"name"] forKey:@"name"];
                [cityDict setObject:[resultSet stringForColumn:@"pinyin"] forKey:@"pinyin"];
                [citys addObject:cityDict];
            }
        }
        [resultSet close];
    }];
    [queue close];
    
    return citys;
}

+ (NSDictionary *)cityDictFromDBs{
    NSString *cityDbPath = [[NSBundle mainBundle] pathForResource:@"ddf_cities" ofType:@"db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:cityDbPath];
    
    NSMutableDictionary *citysDic = [NSMutableDictionary dictionary];
    
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"select * from %@", CitysTableName]];
        while ([resultSet next]) {
            if ([resultSet stringForColumnIndex:0] != nil) {
                
                NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                [cityDict setObject:[NSNumber numberWithInteger:[resultSet intForColumn:@"id"]] forKey:@"id"];
                [cityDict setObject:[resultSet stringForColumn:@"name"] forKey:@"name"];
                [cityDict setObject:[resultSet stringForColumn:@"pinyin"] forKey:@"pinyin"];
                [cityDict setObject:[self sortFactor:cityDict[@"name"]] forKey:@"sortFactor"];
                
                NSString *fWord = [self firstPyName:[resultSet stringForColumn:@"name"]];
                if (citysDic[fWord]) {
                    [citysDic[fWord] addObject:cityDict];
                }else{
                    NSMutableArray *array = [NSMutableArray array];
                    [array addObject:cityDict];
                    [citysDic setObject:array forKey:fWord];
                }
            }
        }
        [resultSet close];
    }];
    [queue close];
    return citysDic;
}

+ (NSString *)sortFactor:(NSString *)name{
    NSString *str = @"";
    for (NSInteger i = 0; i < [name length]; i++){
        str = [NSString stringWithFormat:@"%@%c",str,pinyinFirstLetter([name characterAtIndex:i])];
    }
    return str;
}

+ (NSString *)firstPyName:(NSString *)name{
    NSString *str = [NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])];
    return str;
}

@end
