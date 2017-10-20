//
//  IndexArray.m
//  MEMobile
//
//  Created by LamTsanFeng on 15/7/28.
//  Copyright (c) 2015年 GZMiracle. All rights reserved.
//

#import "IndexArray.h"

NSString *const kIndexArrayListName = @"messageList";

NSString *const kIndexArrayObjectClass = @"IndexArrayObjectClass";
NSString *const kIndexArrayObjectKey = @"IndexArrayObjectKey";


@interface IndexArrayEnumerator : NSEnumerator
{
    // Pointer to the IndexArray instance we are enumerating.
    IndexArray *_IndexArrayInstanceToEnumerate;
    // Current position
    NSUInteger _currentIndex;
}
- (id)initWithIndexArray:(IndexArray*)anIndexArray;
@end

@implementation IndexArrayEnumerator

// -------------------------------------------------------------------------------
//	initWithIndexArray:
//  Designated initializer for this class.
// -------------------------------------------------------------------------------
- (id)initWithIndexArray:(IndexArray*)anIndexArray
{
    self = [super init];
    if (self)
    {
        // Note: If you choose not to use ARC, the enumerator should explicitly
        //       retain the object it is enumerating.
        _IndexArrayInstanceToEnumerate = anIndexArray;
        _currentIndex = 0;
    }
    return self;
}

// -------------------------------------------------------------------------------
//	nextObject
//  You must override this method in any NSEnumerator subclass you create.
//  This method is called repeatedly during enumeration to get the next object
//  until all objects have been enumerated at which point it must return nil.
// -------------------------------------------------------------------------------
- (id)nextObject
{
    if (_currentIndex >= _IndexArrayInstanceToEnumerate.count)
        return nil;
    
    return _IndexArrayInstanceToEnumerate[_currentIndex++];
}

// NOTE: NSEnumerator provides a default implementation of -allObjects that uses
//       -nextObject to fill up an array, which is then returned.  You may wish
//       to provide your own implementation for better performance.

@end

static NSDictionary *IndexArrayObjectClass;

@interface IndexArray ()

/** 此属性名字必需和kIndexArrayListName宏定义一致 */
@property (nonatomic ,strong) NSMutableArray *messageList;
@property (nonatomic ,strong) NSMutableDictionary *messageDict;

@end

@implementation IndexArray

/** 设置序列key */
+ (void)setIndexKey:(NSArray <NSDictionary <NSString *, NSString *>*>*)objects
{
    NSMutableDictionary *objectClass = [@{} mutableCopy];
    for (NSDictionary *dict in objects) {
        NSString *className = dict[kIndexArrayObjectClass];
        NSString *key = dict[kIndexArrayObjectKey];
        if (className && key) { /** 记录数据 */
            [objectClass setObject:key forKey:className];
        }
    }
    IndexArrayObjectClass = [objectClass copy];
}

- (id)init
{
    self = [super init];
    if (self) {
        _messageList = [NSMutableArray array];
        _messageDict = [NSMutableDictionary dictionary];
    }
    return self;
}

/** 监听添加对象 */
- (void)addObjectKVO:(id)object
{
    if ([self.delegate respondsToSelector:@selector(indexArray:addObject:)]) {
        [self.delegate indexArray:self addObject:object];
    }
}

/** 监听移除对象 */
- (void)removeObjectKVO:(id)object
{
    if ([self.delegate respondsToSelector:@selector(indexArray:removeObject:)]) {
        [self.delegate indexArray:self removeObject:object];
    }
}

/** 获取序列key */
+ (NSString *)indexKey:(id)anObject
{
    NSString *key = [self indexSubKey:anObject superClass:nil];
    
    if (key.length == 0) {
        NSLog(@"Object is %@, no match indexKey.", [anObject class]);
    }
    return key;
}

+ (NSString *)indexSubKey:(id)anObject superClass:(Class)superClass
{
    NSString *key = nil;
    
    NSString *className = NSStringFromClass([anObject class]);
    NSString *superClassName = NSStringFromClass(superClass);
    
    /** 优先判断supperClass是否存在 */
    if (superClassName) { /** 当前对象父类获取key */
        /** 递归结束 */
        if ([NSObject isSubclassOfClass:superClass]) {
            return key;
        }
        NSString *objectKey = [IndexArrayObjectClass objectForKey:superClassName];
        if (objectKey.length) {
            key = [anObject valueForKey:objectKey];
        } else if (className) { /** 当前类型找不到，编辑父类匹配 */
            key = [self indexSubKey:anObject superClass:[superClass superclass]];
        }
    } else if (className) { /** 当前对象获取key */
        key = [self indexSubKey:anObject superClass:[anObject class]];
    }
    
    return key;
}

- (NSArray *)list
{
    return [_messageList copy];
}

- (NSDictionary *)dict
{
    return [_messageDict copy];
}

- (NSUInteger)count
{
    return _messageList.count;
}

- (id)firstObject
{
    return [_messageList firstObject];
}

- (id)lastObject
{
    return [_messageList lastObject];
}

/** 序列是否存在 */
- (id)isExistsArrayIndex:(id)anObject
{
    NSString *key = [IndexArray indexKey:anObject];
    
    if (key) {
        return [_messageDict objectForKey:key];
    }
    return nil;
}

/** 增加序列 */
- (void)addArrayIndex:(id)anObject
{
    NSString *key = [IndexArray indexKey:anObject];
    
    if (key) {
        [_messageDict setObject:anObject forKey:key];
    }
}

/** 移除序列 */
- (id)removeArrayIndex:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (key) {
        [_messageDict removeObjectForKey:key];
    }
    return obj;
}

/** 修改序列 */
- (void)setArrayIndexWithOldObject:(id)oldObject newObject:(id)newObject
{
    NSString *key = [IndexArray indexKey:oldObject];
    [self removeArrayIndex:key];
    [self addArrayIndex:newObject];
}

/** 查询数据 */
- (NSUInteger)indexOfObject:(id)anObject
{
    NSString *key = [IndexArray indexKey:anObject];
    id obj = [self objectForKey:key];
    if (obj) {
        return [_messageList indexOfObject:obj];
    } else {
        return [_messageList indexOfObject:anObject];
    }
    return NSNotFound;
}

- (id)objectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
        [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long)index, (unsigned long)self.count];
    
    return [_messageList objectAtIndex:index];
}

- (id)objectForKey:(id)aKey
{
    if (aKey) {
        return [_messageDict objectForKey:aKey];
    }
    return nil;
}

/** 包含序列 */
- (BOOL)containsIndex:(NSString *)key
{
    return [self objectForKey:key] != nil;
}
/** 包含对象 */
- (BOOL)containsObject:(id)anObject
{
    NSString *key = [IndexArray indexKey:anObject];
    if (key) {
        return [self objectForKey:key] != nil;
    } else {
        return [_messageList containsObject:anObject];
    }
}
/** 完全包含数组内的对象 */
- (BOOL)containsArray:(NSArray *)otherArray
{
    BOOL isContains = NO;
    for (id anObject in otherArray) {
        isContains = [self containsObject:anObject];
        if (isContains == NO) {
            break;
        }
    }
    return isContains;
}

/** 匹配 */
- (IndexArray *)sameObjectsInArray:(NSArray *)otherArray
{
    IndexArray *indexArray = [[IndexArray alloc] init];
    
    /** 遍历数据 */
    for (id anObject in otherArray) {
        if ([self containsObject:anObject]) {
            [indexArray addObject:anObject];
        }
    }
    
    return indexArray;
}

- (IndexArray *)differentObjectsInArray:(NSArray *)otherArray
{
    IndexArray *indexArray = [[IndexArray alloc] init];
    
    /** 遍历数据 */
    for (id anObject in otherArray) {
        if ([self containsObject:anObject]) {
            continue;
        }
        [indexArray addObject:anObject];
    }
    
    return indexArray;
}

/** 替换 */
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    id obj = [self objectAtIndex:index];
    if (obj) {
        [self setArrayIndexWithOldObject:obj newObject:anObject];
        [_messageList replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)replaceObject:(id)obj withObject:(id)anObject
{
    NSInteger index = [self indexOfObject:obj];
    if (index != NSNotFound) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

/** 添加数据 */
- (void)addObject:(id)anObject
{
    id existsObject = [self isExistsArrayIndex:anObject];
    if (existsObject) {
        [[self mutableArrayValueForKey:kIndexArrayListName] removeObject:existsObject];
        [self removeObjectKVO:existsObject];
    }
    [self addArrayIndex:anObject];
    [[self mutableArrayValueForKey:kIndexArrayListName] addObject:anObject];
    [self addObjectKVO:anObject];
}

- (void)addObjectsFromArray:(NSArray *)otherArray
{
    for (id anObject in otherArray) {
        [self addObject:anObject];
    }
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes
{
    [objects enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self insertObject:obj atIndex:indexes.firstIndex];
    }];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    id existsObject = [self isExistsArrayIndex:anObject];
    if (existsObject) {
        [[self mutableArrayValueForKey:kIndexArrayListName] removeObject:existsObject];
        [self removeObjectKVO:existsObject];
    }
    [self addArrayIndex:anObject];
    [[self mutableArrayValueForKey:kIndexArrayListName] insertObject:anObject atIndex:index];
    [self addObjectKVO:anObject];
}

- (void)setArray:(NSArray *)otherArray
{
    
    [_messageDict removeAllObjects];
    for (id anObject in otherArray) {
        [self addArrayIndex:anObject];
    }
    [[self mutableArrayValueForKey:kIndexArrayListName] setArray:otherArray];
    for (id anObject in otherArray) {
        [self addObjectKVO:anObject];
    }
}

/** 删除所有数据 */
- (void)removeAllObjects
{
    NSArray *tmpList = [_messageList copy];
    [_messageDict removeAllObjects];
    [[self mutableArrayValueForKey:kIndexArrayListName] removeAllObjects];
    for (id anObject in tmpList) {
        [self removeObjectKVO:anObject];
    }
    tmpList = nil;
}

/** 删除数据 */
- (void)removeObject:(id)anObject
{
    NSString *key = [IndexArray indexKey:anObject];
    id obj = [self removeArrayIndex:key];
    if (!obj && anObject) {
        [[self mutableArrayValueForKey:kIndexArrayListName] removeObject:anObject];
        [self removeObjectKVO:anObject];
    } else if (obj) {
        [[self mutableArrayValueForKey:kIndexArrayListName] removeObject:obj];
        [self removeObjectKVO:obj];
    }
}

- (void)removeObjectsInArray:(NSArray *)otherArray
{
    for (id anObject in otherArray) {
        [self removeObject:anObject];
    }
}

- (void)removeObjectForKey:(id)aKey
{
    id obj = [self objectForKey:aKey];
    if (obj) {
        [_messageDict removeObjectForKey:aKey];
        [[self mutableArrayValueForKey:kIndexArrayListName] removeObject:obj];
        [self removeObjectKVO:obj];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
        [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long)index, (unsigned long)self.count];
    
    id obj = [_messageList objectAtIndex:index];
    if (obj) {
        [self removeObject:obj];
    }
}

- (void)removeLastObject
{
    id obj = _messageList.lastObject;
    if (obj) {
        [self removeObject:obj];
    }
}

- (void)removeObjectsInRange:(NSRange)range
{
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
    NSArray *removeObjs = [_messageList objectsAtIndexes:set];
    for (id obj in removeObjs) {
        [self removeObject:obj];
    }
}

/** 快速遍历 array[i] */
- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    if (idx >= self.count)
        [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long)idx, (unsigned long)self.count];
    return [self objectAtIndex:idx];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    BOOL stop = NO;
    
    for (NSInteger i=0; i<self.count; i++) {
        
        id anObject = self[i];
        
        if (block) {
            block(anObject, i, &stop);
        }
        
        if (stop) {
            break;
        }
    }
}

- (NSEnumerator*)objectEnumerator
{
    return [[IndexArrayEnumerator alloc] initWithIndexArray:self];
}


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])stackbuf
                                    count:(NSUInteger)stackbufLength
{
    NSUInteger count = 0;
    
    unsigned long countOfItemsAlreadyEnumerated = state->state;
    
    if(countOfItemsAlreadyEnumerated == 0)
    {
        state->mutationsPtr = &state->extra[0];
    }
    
    if(countOfItemsAlreadyEnumerated < self.count)
    {
        state->itemsPtr = stackbuf;
        
        while((countOfItemsAlreadyEnumerated < self.count) && (count < stackbufLength))
        {
            stackbuf[count] = _messageList[countOfItemsAlreadyEnumerated];
            
            countOfItemsAlreadyEnumerated++;
            
            count++;
        }
    }
    else
    {
        count = 0;
    }
    
    state->state = countOfItemsAlreadyEnumerated;
    
    return count;
}


/** 排序 */
- (void)sortUsingComparator:(NSComparator)cmptr
{
    [self.messageList sortUsingComparator:cmptr];
}

#pragma mark - NSSecureCoding
#pragma mark 从文件中读取
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        // Decode the property values by key, specifying the expected class
        _messageList = [aDecoder decodeObjectForKey:@"messageList"];
        _messageDict = [aDecoder decodeObjectForKey:@"messageDict"];
    }
    
    return self;
    
}

#pragma mark 写入文件
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.messageList forKey:@"messageList"];
    [aCoder encodeObject:self.messageDict forKey:@"messageDict"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    IndexArray *array = [[[self class] allocWithZone:zone] init];
    array.messageList = [self.messageList mutableCopy];
    array.messageDict = [self.messageDict mutableCopy];
    return array;
}

#pragma mark - 深复制
- (IndexArray *)deepCopy
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

#pragma mark - 描述
- (NSString *)description
{
    return [NSString stringWithFormat:@"list:%@ \n dict:%@", self.list, self.dict];
}

@end

