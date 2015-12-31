# GoogleBlogReader
Sample app using Google Blogger API to post blog post.

Obtain a API KEY from the provider.
Blogger# AIzaSyAxyYEXpJlN_n6-FXMsAVgVbKp1FsYwSsI
Look through Documentation to find a GET Request to test.
You can use JSON Formatter website
When using the GET request it will usually require yout API Key at the end of the URL. It will usually say ?key= Your-API-Key. If there is already a ? reference in the address then -> use:  &key= YOUR-API-KEY
Looking through the JSON data think about what information you really need from the site in order to accomplish the task.
Do you need an id to route to
Do you just need the Dictionary and Key
Find the actual web address you want to pull your data from.
BASE_URL doesnt change
SUB_URL (link to specific part of the site you want)
API_KEY
Open a New Xcode project
Determine what type of view you want (Detail Master in example)
Will you need CORE DATA to save to the device when offline?
Working with CoreData
Entities = is a reference guide. You can have multiple Entities
Attributes = subcategories with actual data to save
Once you establish the Entities and Attributes you need to change the code if you choose the Master Detail template in the MasterViewController & DetailViewController.
Now we need to get the JSON data into the app - In MasterVC > viewDidLoad:
let url = BASE_URL <- Needs to be in a NSURL (String:””)
        let session = NSURLSession.sharedSession();
        
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
           
            if error != nil {
                print(error)
            } else {
                
                if let data = data {
                    print(NSString(data: data, encoding: NSUTF8StringEncoding))
                }  
            }
        }
        
        task.resume()
Now we need to get the JSON converted into an NSDictionary so iOS can use it.
INSERT@  Sect: 8, Row: K ...from above -> if let data = data {
do { let jsonResults = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        print(jsonResults)
                        
                    } catch {}
The catch will contain any ERROR Handling you want in the event the results do not return anything back. You have to use a Do, let, try, catch statement.
Dictionaries will start with {
Arrays will start with (

Next begin extracting the data we need from the JSON data
INSERT@ Sect. 9 Row. ii
 if jsonResults.count > 0 {
                            if let items = jsonResults["items"] as? NSArray {
                              print ("Items is working \(items)")
                            }
                        }
Now to pull the “items” out of the website Data (Json) - names to match CoreData
You will turn the jsonResults into an INT as a .count item so we can first check to see if there is item in the RESULTS.
Then we will loop through the results and grab the data for our CoreData model

          if let items = jsonResults["items"] as? NSArray {    
                        for item in items {
                                
                                if let title = item["title"] as? String {
                                    if let content = item["content"] as? String {
                                        
                                        print(title)
                                        print(content)
                                    }
                                }
                                }
We will now get the JSON data in to our CoreData so it can be saved for offline usage.
In viewDidLoad : 
let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let context: NSManagedObjectContext = appDel.managedObjectContext
So that we do not keep saving the same information to coreData we will write code that will prevent that from happening:
INSERT @ Sect. 10 Row. ii
  let request = NSFetchRequest(entityName: "BlogItems")
                                request.returnsObjectsAsFaults = false
                                
                                do { let results = try context.executeFetchRequest(request)
                                    
                                    if results.count > 0 {
                                        for result in results {
                                            context.deleteObject(result as! NSManagedObject)
                                            
                                            do { try context.save() }
                                            catch{}
This will create a new post in the actual UI by saving it to CoreData
INSERT @ Sect. 11 row. iv
let newPost: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("BlogItems", inManagedObjectContext: context)
                                        
                                        newPost.setValue(title, forKey: "title")
                                        newPost.setValue(content, forKey: "content")

~~~ Your code should look like this at this point and be presenting in the UIView ~~~

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let url = BASE_URL
        let session = NSURLSession.sharedSession();
        
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
           
            if error != nil {
                print(error)
            } else {
                
                if let data = data {
//                    print(NSString(data: data, encoding: NSUTF8StringEncoding))
                    
                    do { let jsonResults = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//                        print(jsonResults)
                        if jsonResults.count > 0 {
                            
                            if let items = jsonResults["items"] as? NSArray {
                                
                                let request = NSFetchRequest(entityName: "BlogItems")
                                request.returnsObjectsAsFaults = false
                                
                                do { let results = try context.executeFetchRequest(request)
                                    
                                    if results.count > 0 {
                                        for result in results {
                                            context.deleteObject(result as! NSManagedObject)
                                            
                                            do { try context.save() }
                                            catch{}
                                            
                                        }
                                    }
                                    
                                } catch {
                                    
                                }
                                
                                for item in items {
                                
                                if let title = item["title"] as? String {
                                    if let content = item["content"] as? String {
                                        
                                        let newPost: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("BlogItems", inManagedObjectContext: context)
                                        
                                        newPost.setValue(title, forKey: "title")
                                        newPost.setValue(content, forKey: "content")
                                        
                                        print(title)
                                        print(content)
                                    }
                                }
                                }
                                
//                                print ("Items is working \(items)")
                            }
                            
                        }
                        
                        
                    } catch {}
                }
            }
        }
        
        task.resume()
        



