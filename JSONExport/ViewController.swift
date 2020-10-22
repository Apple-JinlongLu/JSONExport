//
//  ViewController.swift
//  JSONExport
//
//  Created by 卢金龙 on 11/2/14.
//  Copyright © 2019 Apple-JinlongLu. All rights reserved.
//
//  在满足以下条件的前提下，允许以源格式和二进制格式重新分配和使用，无论是否修改：
//
//  1. 源代码的再分配必须保留上述版权声明、此条件列表和以下免责声明。
//  2. 以二进制形式进行的再分配必须复制上述版权声明、本条件列表以及随再分配提供的文档和/或其他材料中的以下免责声明。
//  3. 未经特定的事先书面许可，不得使用贡献者的名称来认可或推广从本软件派生的产品。
//
//  本软件由版权所有人和贡献者“按原样”提供，任何明示或暗示的保证，包括但不限于对适销性和特定用途适用性的暗示保证，均不予承认。
//  在任何情况下，版权持有人或贡献者对任何直接、间接、偶然、特殊、示范性或后果性损害（包括但不限于采购替代货物或服务；
//  使用、数据或利润损失；或业务中断）概不负责，但这会导致无论是合同责任、严格责任还是因使用本软件而产生的侵权行为
// （包括疏忽或其他），即使已告知此类损害的可能性。
//

import Cocoa

class ViewController: NSViewController, NSUserNotificationCenterDelegate, NSTableViewDelegate, NSTableViewDataSource, NSTextViewDelegate {
    
    //Shows the list of files' preview
    @IBOutlet weak var tableView: NSTableView!
    
    //Connected to the top right corner to show the current parsing status
    @IBOutlet weak var statusTextField: NSTextField!
    
    //Connected to the save button
    @IBOutlet weak var saveButton: NSButton!
    
    //Connected to the JSON input text view
    @IBOutlet var sourceText: NSTextView!
    
    //Connected to the scroll view which wraps the sourceText
    @IBOutlet weak var scrollView: NSScrollView!
    
    //Connected to Constructors check box
    @IBOutlet weak var generateConstructors: NSButtonCell!
    
    //Connected to Utility Methods check box
    @IBOutlet weak var generateUtilityMethods: NSButtonCell!
    
    //Connected to root class name field
    @IBOutlet weak var classNameField: NSTextFieldCell!
    
    //Connected to parent class name field
    @IBOutlet weak var parentClassName: NSTextField!
    
    //Connected to class prefix field
    @IBOutlet weak var classPrefixField: NSTextField!
    
    //Connected to the first line statement field
    @IBOutlet weak var firstLineField: NSTextField!
    
    //Connected to the languages pop up
    @IBOutlet weak var languagesPopup: NSPopUpButton!
    
    
    //Holds the currently selected language
    var selectedLang : LangModel!
    
    //Returns the title of the selected language in the languagesPopup
    //Call only from main thread
    var selectedLanguageName : String
    {
        assert(Thread.isMainThread);
        return languagesPopup.titleOfSelectedItem!
    }
    
    //Should hold list of supported languages, where the key is the language name and the value is LangModel instance
    var langs : [String : LangModel] = [String : LangModel]()
    
    //Holds list of the generated files
    var files : [FileRepresenter] = [FileRepresenter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        sourceText.isAutomaticQuoteSubstitutionEnabled = false
        loadSupportedLanguages()
        setupNumberedTextView()
        setLanguagesSelection()
        loadLastSelectedLanguage()
        updateUIFieldsForSelectedLanguage()
	self.tableView.backgroundColor = .clear
    }
    
    /**
     Sets the values of languagesPopup items' titles
     */
    func setLanguagesSelection()
    {
        let langNames = Array(langs.keys).sorted()
        languagesPopup.removeAllItems()
        languagesPopup.addItems(withTitles: langNames)
        
    }
    
    /**
     Sets the needed configurations for show the line numbers in the input text view
     */
    func setupNumberedTextView()
    {
        let lineNumberView = NoodleLineNumberView(scrollView: scrollView)
        scrollView.hasHorizontalRuler = false
        scrollView.hasVerticalRuler = true
        scrollView.verticalRulerView = lineNumberView
        scrollView.rulersVisible = true
        sourceText.font = NSFont.userFixedPitchFont(ofSize: NSFont.smallSystemFontSize)
        
    }
    
    /**
     Updates the visible fields according to the selected language
     */
    func updateUIFieldsForSelectedLanguage()
    {
        loadSelectedLanguageModel()
        if selectedLang.supportsFirstLineStatement != nil && selectedLang.supportsFirstLineStatement!{
            firstLineField.isHidden = false
            firstLineField.placeholderString = selectedLang.firstLineHint
        }else{
            firstLineField.isHidden = true
        }
        
        if selectedLang.modelDefinitionWithParent != nil || selectedLang.headerFileData?.modelDefinitionWithParent != nil{
            parentClassName.isHidden = false
        }else{
            parentClassName.isHidden = true
        }
    }
    
    /**
     Loads last selected language by user
     */
    func loadLastSelectedLanguage()
    {
        guard let lastSelectedLanguage = UserDefaults.standard.value(forKey: "selectedLanguage") as? String else{
            return
        }
        
        if langs[lastSelectedLanguage] != nil{
            languagesPopup.selectItem(withTitle: lastSelectedLanguage)
        }
    }
    
    //MARK: - Handling pre defined languages
    func loadSupportedLanguages()
    {
		if let langFiles = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil){
            for langFile in langFiles{
                if let data = try? Data(contentsOf: langFile), let langDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? NSDictionary{
                    let lang = LangModel(fromDictionary: langDictionary)
                    if langs[lang.displayLangName] != nil{
                        continue
                    }
                    langs[lang.displayLangName] = lang
                }
            }
        }
    }

    
    // MARK: - parse the json file
    func parseJSONData(jsonData: Data!)
    {
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        sourceText.string = jsonString!
    }
    
    //MARK: - Handlind events
    
	@IBAction func openJSONFiles(sender: AnyObject)
	{
		let oPanel: NSOpenPanel = NSOpenPanel()
		oPanel.canChooseDirectories = false
		oPanel.canChooseFiles = true
		oPanel.allowsMultipleSelection = false
		oPanel.allowedFileTypes = ["json","JSON"]
		oPanel.prompt = "Choose JSON file"
		
		oPanel.beginSheetModal(for: self.view.window!) { button in
			if button.rawValue == NSFileHandlingPanelOKButton {
				let jsonPath = oPanel.urls.first!.path
				let fileHandle = FileHandle(forReadingAtPath: jsonPath)
				let urlStr:String  = oPanel.urls.first!.lastPathComponent
				self.classNameField.stringValue = urlStr.replacingOccurrences(of: ".json", with: "")
				self.parseJSONData(jsonData: (fileHandle!.readDataToEndOfFile()))
			}
		}
	}
    
    
    @IBAction func toggleConstructors(_ sender: AnyObject)
    {
        generateClasses()
    }
    
    
    @IBAction func toggleUtilities(_ sender: AnyObject)
    {
        generateClasses()
    }
    
    @IBAction func rootClassNameChanged(_ sender: AnyObject) {
        generateClasses()
    }
    
    @IBAction func parentClassNameChanged(_ sender: AnyObject)
    {
        generateClasses()
    }
    
    
    @IBAction func classPrefixChanged(_ sender: AnyObject)
    {
        generateClasses()
    }
    
    
    @IBAction func selectedLanguageChanged(_ sender: AnyObject)
    {
        updateUIFieldsForSelectedLanguage()
        generateClasses()
        DispatchQueue.main.async {
            UserDefaults.standard.set(self.selectedLanguageName, forKey: "selectedLanguage")
        }
        
    }
    
    
    @IBAction func firstLineChanged(_ sender: AnyObject)
    {
        generateClasses()
    }
    
    //MARK: - NSTextDelegate
    
    func textDidChange(_ notification: Notification) {
        generateClasses()
    }
    
    
    //MARK: - Language selection handling
    func loadSelectedLanguageModel()
    {
       selectedLang = langs[self.selectedLanguageName]
    }
    
    
    //MARK: - NSUserNotificationCenterDelegate
    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool
    {
        return true
    }
    
    
    //MARK: - Showing the open panel and save files
    @IBAction func saveFiles(_ sender: AnyObject)
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsOtherFileTypes = false
        openPanel.treatsFilePackagesAsDirectories = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.prompt = "Choose"
		openPanel.beginSheetModal(for: self.view.window!){ button in
			if button.rawValue == NSFileHandlingPanelOKButton{
				self.saveToPath(openPanel.url!.path)
				self.showDoneSuccessfully()
			}
		}
    }
    
    
    /**
     Saves all the generated files in the specified path
     
     - parameter path: in which to save the files
     */
    func saveToPath(_ path : String)
    {
        var error : NSError?
        for file in files{
            var fileContent = file.fileContent
            if fileContent == ""{
                fileContent = file.toString()
            }
            var fileExtension = selectedLang.fileExtension
            if file is HeaderFileRepresenter{
                fileExtension = selectedLang.headerFileData.headerFileExtension
            }
            let filePath = "\(path)/\(file.className).\(fileExtension)"
            
            do {
                try fileContent.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil{
                showError(error!)
                break
            }
        }
    }
    
    
    //MARK: - Messages
    /**
     Shows the top right notification. Call it after saving the files successfully
     */
    func showDoneSuccessfully()
    {
        let notification = NSUserNotification()
        notification.title = "Success!"
        notification.informativeText = "Your \(selectedLang.langName) model files have been generated successfully."
        notification.deliveryDate = Date()
        
        let center = NSUserNotificationCenter.default
        center.delegate = self
        center.deliver(notification)
    }
    
    /**
     Shows an NSAlert for the passed error
     */
    func showError(_ error: NSError!)
    {
        if error == nil{
            return;
        }
        let alert = NSAlert(error: error)
        alert.runModal()
    }
    
    /**
     Shows the passed error status message
     */
    func showErrorStatus(_ errorMessage: String)
    {
        
        statusTextField.textColor = NSColor.red
        statusTextField.stringValue = errorMessage
    }
    
    /**
     Shows the passed success status message
     */
    func showSuccessStatus(_ successMessage: String)
    {
        
        statusTextField.textColor = NSColor.green
        statusTextField.stringValue = successMessage
    }
    
    
    
    //MARK: - Generate files content
    /**
     Validates the sourceText string input, and takes any needed action to generate the model classes and view them in the preview panel
     */
    func generateClasses()
    {
        saveButton.isEnabled = false
        var str = sourceText.string
        
        if str.count == 0{
            runOnUiThread{
                //Nothing to do, just clear any generated files
                self.files.removeAll(keepingCapacity: false)
                self.tableView.reloadData()
            }
            return;
        }
        var rootClassName = classNameField.stringValue
        if rootClassName.count == 0{
            rootClassName = "RootClass"
        }
        sourceText.isEditable = false
        //Do the lengthy process in background, it takes time with more complicated JSONs
        runOnBackground {
            str = stringByRemovingControlCharacters(str)
            if let data = str.data(using: String.Encoding.utf8){
                var error : NSError?
                do {
                    let jsonData : Any = try JSONSerialization.jsonObject(with: data, options: [])
                    var json : NSDictionary!
                    if jsonData is NSDictionary{
                        //fine nothing to do
						json = jsonData as? NSDictionary
                    }else{
                        json = unionDictionaryFromArrayElements(jsonData as! NSArray)
                    }
                    
                    runOnUiThread{
                        self.loadSelectedLanguageModel()
                        self.files.removeAll(keepingCapacity: false)
                        let fileGenerator = self.prepareAndGetFilesBuilder()
                        fileGenerator.addFileWithName(&rootClassName, jsonObject: json, files: &self.files)
                        fileGenerator.fixReferenceMismatches(inFiles: self.files)
                        self.files = Array(self.files.reversed())
                        self.sourceText.isEditable = true
                        self.showSuccessStatus("有效的JSON结构")
                        self.saveButton.isEnabled = true
                        
                        self.tableView.reloadData()
                        self.tableView.layout()
                    }
                } catch let error1 as NSError {
                    error = error1
                    runOnUiThread({ () -> Void in
                        self.sourceText.isEditable = true
                        self.saveButton.isEnabled = false
                        if error != nil{
                            print(error!)
                        }
                        self.showErrorStatus("JSON对象无效！")
                    })
                    
                } catch {
                    fatalError()
                }
            }
        }
    }
    
    /**
     Creates and returns an instance of FilesContentBuilder. It also configure the values from the UI components to the instance. I.e includeConstructors
     
     - returns: instance of configured FilesContentBuilder
     */
    func prepareAndGetFilesBuilder() -> FilesContentBuilder
    {
        let filesBuilder = FilesContentBuilder.instance
        filesBuilder.includeConstructors = (generateConstructors.state == NSControl.StateValue.on)
        filesBuilder.includeUtilities = (generateUtilityMethods.state == NSControl.StateValue.on)
        filesBuilder.firstLine = firstLineField.stringValue
        filesBuilder.lang = selectedLang!
        filesBuilder.classPrefix = classPrefixField.stringValue
        filesBuilder.parentClassName = parentClassName.stringValue
        return filesBuilder
    }
    
    
    
    
    //MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return files.count
    }
    
    
    //MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("fileCell"), owner: self) as! FilePreviewCell
        let file = files[row]
        cell.file = file
        
        return cell
    }
    
    
    
}
