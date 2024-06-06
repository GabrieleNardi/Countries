# ``Countries``
The Countries Application's goal is to obtain informations about countries of the world.

The countries are presented into a collectionView, and once tapped one item of the list, further datails of the country are displayed. 
The User can also filter countries by continent, language, or by writing the name of a country, or change the order of the list of countries(the default order is the alphabetical one).
APIs containing the informations used by the app can be found [here](https://restcountries.com).

## Folder structure

### Directories

The following section describe the structure of the project's directory.

- `/Countries`: This is the main application's directory; you will run the project from the `Countries.xcodeproj`.
- `/Frameworks`: Contains the list of all frameworks of the app. Main app imports these dependencies via SPM in order to provide its features.


### Frameworks

To helps modularity and separation of responsibilities the Application is splitted is several modules: 

- **Commons**: An utility module contains useful services. 
- **Core**: It contains core dependencies to be implemented in the application.
- **DataModel**: Main models of the application.
- **Mock**: A mock module used to mock data and dependecies if needed.

## Application architecture

### AppDependencies
 
AppDependencies specify the list of loadable services and the remote configuration in use.

### Microservices

Microservices are an architectural and organizational approach to software development in which software is composed of small, independent services that communicate through well-defined APIs. Each of these services corresponds to a specific framework.

### MVVM

### View

`UIViewController`s that contain no business logic and are a function of the state.
Side effects are triggered by the user's actions (such as a tap on a button) or view lifecycle event `loadView` and are forwarded to the ViewModel.
State and business logic layer (State + ViewModel) are injected into the view hierarchy via the init method.

### ViewModel

ViewModels receive requests to perform operations, such as getting data from an external source or performing calculations, but they never return data directly.
Instead, they forward the result to a `Binding` or `Publisher`. The latter is used when the result of the operation (the model) is used locally by a view.

## UI/UX

The UI and UX are simple and fluid(if you want more you can look at Figma project [here](https://www.figma.com/file/Rg0KO5TSLRIoEIcySUTDWh/ZEXTRAS-Countries?type=design&node-id=2%3A113&mode=design&t=JjFRRWS7Q1cW486K-1).  

### List

The main screen of the application is a list that shows the countries' flag, name and continent. If you tap on the item you can access to the country detail screen with further more informations.

### Filters

The user can filter countries by continent or languages through a tap on an item of a list which appears as a modal on the main screen. 

### Detail

Once tapped an item on the main screen you can access more informations about the selected country.

## Persistence

The application use `CoreData` as DB. You just need to load countries once to store them.
Every time you launch the application the countries are overwritten.

## Localization

The application is localized into english and italian languages using the `LocalizedStringResource` technology.

## Additional APIs

The detail section displays photo shooted or reguarding that specific country. By doing this we avail the [Pexels APIs](https://www.pexels.com).  

## Author

Countries App was developed by [Gabriele Nardi](mailto:gabriele.nardi.dev@gmail.com).
