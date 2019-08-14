# JSONEXport中文版，

  Mac下JSON字符串转Model对象工具。
  JSONExport是适用于Mac OS X的桌面应用程序，它使您能够将JSON对象作为模型类导出，并使用您喜欢的语言创建相关的构造函数，实用程序方法，setter和getter。
  
#### JSONExport是用Swift编写的Mac OS X桌面应用程序。使用JSONExport，您将能够：

  * 将任何有效的JSON对象转换为当前支持的语言之一的类。
  * 在保存之前预览生成的内容。
  * 仅包含构造函数，仅包含实用程序方法，包括两者或不包含。
  * 更改根类名，默认RootClass。
  * 为生成的类设置类名前缀。
  * 设置Java文件的包名称。
  
## 生成的文件

#### 每个生成的文件，besid getter和setter（对于Java）都可以包括：

  * 一个构造函数，它接受一个NSDictionary，JSON，JSONObject实例的实例，具体取决于文件语言，该类将使用该对象来填充其属性数据。
  * 一种实用程序方法，它将类数据再次转换为字典。

## 目前支持编程的语言

#### 目前，您可以将JSON对象转换为以下语言之一：
1. Java Gson for Android.
2. Java for Realm Android.
3. Java for Android
4. Objective-C - CoreData.
5. Objective-C - MAC.
6. Objective-C for Realm iOS.
7. Objective-C - iOS.
8. Swift Classes.
5. Swift Classes for SwiftyJSON library.
6. Swift Classes for Realm.
7. Swift - CoreData.
8. Swift Structures.
9. Swift Structures for Gloss
10. Swift Mappable Classes for (Swift 3) ObjectMapper
11. Swift Structures for Unbox








