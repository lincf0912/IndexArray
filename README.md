# IndexArray

* 包含字典与数组的结合对象，基本跟NSArray的用法一样；
* 可以直接将NSArray替换为IndexArray使用。

## Installation 安装

* CocoaPods：pod 'IndexArray'
* 手动导入：将IndexArrayDEMO\class文件夹拽入项目中，导入头文件：#import "IndexArray.h"

## 调用代码

### 初始化序列
* + (void)setIndexKey:(NSArray <NSDictionary <NSString *, NSString *>*>*)objects;

* IndexArray *indexArray = [IndexArray new];
* [indexArray addObject:obj];

* NSLog(@"Get objects at index : %@", [indexArray objectAtIndex:5]);
* NSLog(@"Get objects at index : %@", [indexArray objectAtIndex:15]);

* NSLog(@"Get objects at key : %@", [indexArray objectForKey:@"ew1uiw"]);
* NSLog(@"Get objects at key : %@", [indexArray objectForKey:@"fwne22"]);
