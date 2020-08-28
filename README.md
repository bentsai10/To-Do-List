# To-Do-List
 To-do app with notifications and checkboxes for all the forgetful people out there

Forget iPhone's base reminders app, this will be your new go-to digital to-do list!

<p align = "center"><kbd><img src = "/images/responsive_iphone_se.png" height = "400"></kbd></p>

<p><strong>To-Do List's purpose:</strong><br>Allow users to never forget a task again with notification feature, elaborate on their tasks with a note feature, and 
feel good when they finish a task with a checkbox feature.</p>

<h3> Using To-Do List</h3>
<ul>
  <li>Own a Mac (Sorry PC users :( )</li>
  <li>Download XCode</li>
  <li>To-Do List was created using XCode 11.6, so make sure you have that or a higher version!</li>
  <li>Go to the "Code" dropdown above and select "Open in XCode!"</li>
  <li>Never forget anything again! (Unless you forget to put the task on your to-do list)</li>
</ul>

<h3>How To-Do List Works</h3>
<ol>
  <li>Allow Notifications</li>
  <br>
  <p align = "center"><kbd><img src = "/images/notification_prompt.gif" height = "500"></kbd></p>
  <li>Add a task by naming it, enabling a reminder time should you need it, and write some notes if necessary</li>
  <br>
  <p align = "center"><kbd><img src = "/images/add_task.gif" height = "500"></kbd></p>
  <li>If you made a typo or want to add notes, you can always edit tasks and save them</li>
  <br>
  <p align = "center"><kbd><img src = "/images/edit_task.gif" height = "500"></kbd></p>
  <li>On the home page table view, you can also rearrange or delete your saved tasks</li>
  <br>
  <p align = "center"><kbd><img src = "/images/edit_delete_tasks.gif" height = "500"></kbd></p>
  <li>Get notified when it's time to complete your task</li>
  <br>
  <p align = "center"><kbd><img src = "/images/notification.gif" height = "500"></kbd></p>
  <li>When finished, feel good about yourself by checking that task off the list!</li>
  <br>
  <p align = "center"><kbd><img src = "/images/checked_task.gif" height = "500"></kbd></p>
</ol>
<h3>Logic Behind To-Do List</h3>
<ul>
  <li>Save/Load user data for To-Do List</li>
  <ul>
    <li>Locate documentURL for storing data pertaining to To-Do List app</li>
    <li>Encode all to-do items in "itemsArray" to JSON format</li>
    <li>Try writing this JSON format data into the located document</li>
    <li>To load, the first step is the same, but now data is retrieved from the document
   and decoded from JSON to its intended format</li>
   <li>A completion handler is present to ensure tableView does not load before data from document finishes loading</li>
  </ul>
  
```swift
func saveData(){
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
    let jsonEncoder = JSONEncoder()
    let data = try? jsonEncoder.encode(itemsArray)
    do {
        try data?.write(to: documentURL, options: .noFileProtection)
    } catch {
        print("ERROR: Could not save data \(error.localizedDescription)")
    }
    setNotifications()
}

func loadData(completed: @escaping ()->()) {
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")

    guard let data = try? Data(contentsOf: documentURL) else {return}
    let jsonDecoder = JSONDecoder()
    do {
        itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
    }catch{
        print("ERROR: Could not load data \(error.localizedDescription)")
    }
    completed()
}
```
  <li>Requesting Notification Permission:</li>
  <ul>
    <li>Call requestAuthorization method to notify user of notification type and request permission</li>
    <li>Prompt only appears when app opened initially, stores user choice in settings app separately</li>
    <li>An alert appears when user denies notification informing them how to turn it back on</li>
  </ul>
  
```swift
static func authorizeLocalNotifications(viewController: UIViewController) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        guard error == nil else {
            print("ERROR: \(error!.localizedDescription)")
            return
        }
        if granted {
            print("Notifications Authorization Granted!")
        } else {
            print("The user has denied notifications")
            DispatchQueue.main.async {
                viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications")

            }
        }
    }
}
```
  <li>Setting Calendar Notifications</li>
  <ul>
    <li>Function takes in parameters that will take in data passed by a To-Do List item (title = item.name, body = item.notes, date = item.date, etc.)</li>
    <li>Data from parameters is used to create a UNMutableNotificationContent object called "content"</li>
    <li>Trigger for notification is created on the exact year, month, day, hour, minute user has chosen</li>
    <li>Unique notificationID then created from UUIDString</li>
    <li>UNNotificationRequest object created with aforementioned id, content, and trigger</li>
    <li>UNNotificationRequest added to UserNotificationCenter, meaning notification is properly scheduled. Console prints error message if not the case</li>
  </ul>

```swift
static func setCalendarNotifications(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.body = body
    content.badge = badgeNumber
    content.sound = sound

    var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    dateComponents.second = 00
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

    let notificationID = UUID().uuidString
    let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) {(error) in
        if let error = error {
            print("ERROR: \(error.localizedDescription). Adding notification request went wrong.")
        }else {
            print("Notification scheduled \(notificationID), title: \(content.title)")
        }
    }
    return notificationID
}
```
</ul>

<h3>To-DO List is responsive across iPads and iPhones!</h3>
<h6><em>(Displayed images are of iPad, iPhone 11, and iPhone SE in that order)</em></h6>
<p align = "center"><kbd><img src = "/images/responsive_ipad.png" height = "500"></kbd></p>
<br>
<p align = "center"><kbd><img src = "/images/responsive_iphone_11.png" height = "500"></kbd><img src = "/images/white_space.png" width = "100"><kbd><img src = "/images/responsive_iphone_se.png" height = "500"></kbd></p>
