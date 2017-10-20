//
//  IndexArray.h
//  MEMobile
//
//  Created by LamTsanFeng on 15/7/28.
//  Copyright (c) 2015年 GZMiracle. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 操作数组（监听KVO） */
extern NSString *const kIndexArrayListName;

/** 设置对象类型 */
extern NSString *const kIndexArrayObjectClass;
/** 设置对象序列id */
extern NSString *const kIndexArrayObjectKey;

@class IndexArray;
@protocol IndexArrayDelegate <NSObject>
@optional
/** 监听新增对象 */
- (void)indexArray:(IndexArray *)indexArray addObject:(id)object;
/** 监听移除对象 */
- (void)indexArray:(IndexArray *)indexArray removeObject:(id)object;

@end

@interface IndexArray <__covariant ObjectType>: NSObject <NSFastEnumeration, NSSecureCoding, NSCopying>

@property (nonatomic ,readonly) NSArray *list;
//@property (nonatomic ,readonly) NSDictionary *dict;
@property (readonly) NSUInteger count;
@property (nonatomic, readonly) id firstObject;
@property (nonatomic, readonly) id lastObject;
@property (nonatomic, weak) id<IndexArrayDelegate> delegate;

/**
 设置序列key

 @param objects （object.id ==>  @[@{kIndexArrayObjectClass:object.className, kIndexArrayObjectKey:@"id"}];）
 */
+ (void)setIndexKey:(NSArray <NSDictionary <NSString *, NSString *>*>*)objects;
/** 获取序列key */
+ (NSString *)indexKey:(id)anObject;

/** 增加序列 */
- (void)addArrayIndex:(id)anObject;
/** 移除序列 */
- (id)removeArrayIndex:(NSString *)key;
/** 修改序列 */
- (void)setArrayIndexWithOldObject:(id)oldObject newObject:(id)newObject;

/** 查询数据 */
- (NSUInteger)indexOfObject:(id)anObject;

- (id)objectAtIndex:(NSUInteger)index;

- (id)objectForKey:(id)aKey;

/** 包含序列 */
- (BOOL)containsIndex:(NSString *)key;
/** 包含对象 */
- (BOOL)containsObject:(id)anObject;
/** 完全包含数组内的对象 */
- (BOOL)containsArray:(NSArray *)otherArray;

/** 匹配 */

/** 与otherArray匹配相同的对象，返回新IndexArray */
- (IndexArray *)sameObjectsInArray:(NSArray *)otherArray;
/** 与otherArray匹配，在otherArray中不存在的对象，返回新IndexArray */
- (IndexArray *)differentObjectsInArray:(NSArray *)otherArray;

/** 替换 */
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)replaceObject:(id)obj withObject:(id)anObject;

/** 添加数据 */
- (void)addObject:(id)anObject;

- (void)addObjectsFromArray:(NSArray *)otherArray;

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)setArray:(NSArray *)otherArray;

/** 删除所有数据 */
- (void)removeAllObjects;

/** 删除数据 */
- (void)removeObject:(id)anObject;

- (void)removeObjectsInArray:(NSArray *)otherArray;

- (void)removeObjectForKey:(id)aKey;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeLastObject;

- (void)removeObjectsInRange:(NSRange)range;

/** 快速遍历 array[i] */
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (NSEnumerator*)objectEnumerator;

/** 排序 */
- (void)sortUsingComparator:(NSComparator)cmptr;

/** 深复制 */
- (IndexArray *)deepCopy;
@end
