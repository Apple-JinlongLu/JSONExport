# JSONEXport中文版

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
2. Java Realm for Android.
3. Java for Android
4. Objective-C - CoreData.
5. Objective-C - MAC.
6. Objective-C - Realm.
7. Objective-C - iOS.
8. Swift Classe.
5. Swift Classes for SwiftyJSON library.
6. Swift Classes for Realm.
7. Swift - CoreData.
8. Swift Structures.
9. Swift Structures for Gloss
10. Swift Mappable Classes for (Swift 3) ObjectMapper
11. Swift Structures for Unbox

  屏幕截图显示了用于Twitter时间轴JSON的片段并将其转换为Swift-CoreData的JSONExport。
![blockchain](https://github.com/JinlongLu-iOS/MyImage/blob/master/屏幕快照%202019-08-14%20下午4.56.34.png)

Installation
========================
Kindly clone the project, and build it using xCode 8 and above.

To Do
========================
* ~~Support Objective-C~~ Done
* ~~Sync multible classes with the same name or have the same exact properties~~ Done
* ~~Support to parse JSON arrays of objects~~ Done
* Load JSON data from web
* ~~Open .json files from JSONExport~~
* Supported languages management editor.
* Beside raw JSON, load the model raw data from plist files as well.


Known Limitations:
========================
* When exporting to subclasses of NSManagedObject, some data types can not be exported. For example core data does not have data type for "array of strings"; in turn, if your JSON contains an array of strings, the exported file will not compile without you fixing the type mismatch.
* When exporting subclasses of RLMObject, you will have to enter the default values of premitive types manually. This is because of dynamic properties limition that prevents you from having an optional premitive type.
* When exporting to CoreData or Realm and you want to use the utility methods, you will need to manually watch for deep relation cycle calls; that is, when you convert an object to dictionary, this object try to convert one of its relation to a dictionary and the relation tries to convert the original object to a dictionary, that will cause a kind of cycle where each object involved calls the other object's toDictionary method infenitly...
* Avoid attempt to model a JSON object with empty values, because JSONExport does not understand empty values and can not guess their types.
* Deep nesting of arrays and objects will not be exported in a proper model files.


Final Note
========================
The application still in its early stage. Please report any issue so I can improve it.

License
========================
JSONExport is available under custom version of **MIT** license.





