# Demo App

**Instructions:**

1) run 'pod install'


# Summary

This App is a demo that retrieves a list of posts from an API endpoint and displays the individual details in a Detail Page (author and comments).
It's been developed following a VIPER design pattern, SOLID principles, TDD approach for testing.
The app contains some feature of Swift 5 and XCode Version 11.0 has been used to develop it

## Mobile Architecture

The app is built following a VIPER design pattern. It is a complex pattern and not recommendable for a very small application, but this is great for production complex apps for many aspects:


**Separation of concerns**

It has very clear politics about responsibility for each component. It helps with reducing amount of code in files and putting into the right place according to a single responsibility principle.


**Modularisation**

A VIPER project is very well structured and principles are clearly separated, making possible, for different developers, to work on the same module at the same time. In this way it is easy to divide the work even inside the same feature.

Furthermore, it is great for Reusability, making it easier and cleaner to reuse code over the application and over different applications.
Organising the code by modules helps to separate the app concepts, breaking down the code into independent testable pieces where each one provides a public interface to use the module.


**Protocol oriented**

This helps abstracting features from their implementation, with the use of dependency injection it is really easy to mock parts of the code to specifically test some others. 


**Testing**

For this reason TDD is a great testing approach for this design pattern. 
I have written testing code for each layer following a TDD approach.


**S.O.L.I.D**

Implementing an application successfully following a VIPER pattern helps in comforting with the SOLID principles.

These principles, when combined together, make it easy for a programmer to develop software that is easy to maintain, extend, test and refactor code.

Thanks to these principles, it’s possible to solve the main problems of a bad architecture:
- Fragility: A change may break unexpected parts—it is very difficult to detect if you don’t have a good test coverage

- Immobility: A component is difficult to reuse in another project—or in multiple places of the same project—because it has too many coupled dependencies

- Rigidity: A change requires a lot of efforts because affects several parts of the project


To guarantee the compliance with the SOLID standards, I have added more layers to the VIPER architecture.

The Interactor works as a manager and communicates with a data layer composed by:
- Local Data storage

- Api 

- Parser



## Notes of the implementation:

**Local Storage**

I have used Realm over the native CoreData or other third parties solutions.
The reason behind my choice are simple, mainly for a habit, even if Apple improved CoreData setup and syntax, I find Realm very easy to implement and saves me time. Concurrency is great and it has been built with performance in mind and it is faster, maybe not noticeable for this demo application. Their Mac application which is a GUI of the database is a useful tool.


**Access Control**

I have mainly used Internal (default) classes and members (they can be accessed anywhere within the same module they are defined) and private.
I haven’t used open or public much as there was no need to access to classes or members outside the target.


**UI**

I didn’t focus on the User Interface. I gave priority to show different kind of UI implementations (E.g. collectionView in the posts page and tableView in the details page) and adding small features like the search bar to highlight the responsibilities of each layer (View and Presenter).

I have focussed only on developing an application that looks as desirable both on iPhones and iPads (with some adjustments, i.e the collectionView layout in the Posts page) and also paying attention on screen rotations.
However the final user interface is very basic and can drastically be improved. 


**Model Structure**

In a simplistic way, we can state that for each model class, there are 3 different “implementations”:

- Permanent Storage Data Class (in our case Realm Object)

- Class (Struct or Class)

- ViewModel Class (for the view, to keep the model separated from the view)


E.g.


- RealmUser is the Realm object. They are the objects retrieved (and that we store) from/into the local permanent store. If in the future there’s need to go away from Realm and use i.e. Core Data, we just need to change the Realm objects and the particular part of the code in charge of store/retrieve to/from permanent storage, without having to change any other layers.

- User. It is the object used by the interactor. The interactor manages this object and it sends a User to the dataManager that converts it to i.e a Realm Object.

- UserViewModel. It is a object managed by the View and the Presenter, it is “user interface oriented”


**API Requests and manage async Operations**

I have used NSURLSession to make API requests (and Codable to parse) and I have used PromiseKit as it lets you separate error and success handling, which makes it easier to write clean code that handles many different conditions.
I have used PromiseKit only in “DemoNSURLSessionManager” as a showcase as VIPER architecture uses a system of protocols to manage the communications between layers. 
Also, with Swift 5 Apple has introduced “Result” which is great for this cases. I have used it in the parsing function. Result manages async operations, while parsing it is generally a sync operation and doesn’t require a completion handler, but I wanted to try it and it can be useful for future implementations. 


**SwiftLint**

I have imported swxftlint. I use it to ensure to be consistent with the code style and conventions through the whole application.


**Config Environments**

I have set up 5 different environments, not very useful for this app, but absolutely fundamental in a production app. 

- Mock: it retrieves information from jsons files

In this app all the other 4 environments call the same API baseurl, but it is possible to set it and customise it. They also have a different plist each

- Dev

- QA

- UAT

- Prod


**Resources**

To speed up with the development, I have used some external resources for the hud/loading animation.


**Constants**

I have organised all the error messages and constants in structures and put them in a file (Global.swift). 

In this way there are no strings in the code, but everything is collected in these structures and easy to add a localisation if needed or edit them. 

**RxSwift**

RxSwift is a useful Reactive Programming framework that helps responding to data changes and user events.
It is widely used in applications as they can react to changes in the data without telling it to do so,  making it easier to focus on the logic at hand rather than maintaining a particular state.

It can be used independently by the architecture adopted, however it can be very handy in applications following the MVVM design pattern where the view model doesn't hold a reference of the view, so observation is even more a key factor.

As a showcase, I have decided to implement one module (posts) following the standard VIPER architecture where each layers holds references to the connected layers (E.g. presenter holds a reference to view and interactor), and a part of the Details module (View-Presenter relation) using RxSwift as an example of alternative implementation using Reactive Programming.

**Warnings**

Building the application results in few warnings. They are from pods and due to SwiftLint. 

## Notes of missing implementations:


**UI Testing**
I have written testing code for each layer following a TDD approach, ensuring to have a 100% test coverage (except for the view layer and I haven’t implemented UI testing as it very simple UI).


**Dev-Ops (or Dev-Sev-Ops)**
This demo example is not integrated in a CI/CD pipeline.
Part of my current daily job is to focus not only on the application itself, but also on the operational part, on Dev-Ops.

A production app without automation is not optimised at all. For this reason I would suggest to setup a CI/CD pipeline, that builds the app, run the automation testing (and possibly also security testing) and it release it and deploy it to specific environment (Dev, UAT etc).

Depending on the size of the project and the business decisions, I would use Fastlane, or Jenkins or any other provider (CircleCi, TeamCity etc)






