# The API Awakens App
## Treehouse iOS Project 6

The API Awakens App is an app that uses the Star Wars API(SWAPI) [https://swapi.co](https://swapi.co) to fetch information about three types of Star Wars entities: people, vehicles, and starships.
Regardless of which view a user is on, there is a bar across the bottom showing the largest and smallest member of the group. In addition, becase all measurements are given in metric units (meters), there is a feature that can convert the metric units to British units (inches), at a tap of a button. 
For starships and vehicles, users can convert "Galactic Credits" to US Dollars, based on an exchange rate provided by the the user in a text field.

This project contains the use of:
* Storyboards
* MVVM
* APIs
* Dynamic UITableViews and Custom Cells
* Networking
* Concurrency
* JSON and Data Modelling
* Autolayout
* Generics
* Error Handling

### Project Instructions

1. Create the appropriate types for people, vehicles, and starships. Consider your options in terms of structs, classes, composition, inheritance, etc.

2. Create asynchronous networking code to retrieve JSON results from the SWAPI API. Make sure your code is reusable for the different entities (people, vehicles, starships) that you will be handling and displaying.

3. Create logic to parse the JSON result and display the names of all members of the entities in the Picker Wheel. You may need to check documentation for guidance on how to use the Picker control.

4. Create three screen layouts which users can switch between. One each for people, starships, and vehicles. Make use of reusable elements, storyboards, etc. as you see fit. One possibility is to use a single layout and change/show/hide UI elements programmatically.

5. Create logic such that when a user selects from the pick wheel, all the related fields on the screen are being populated.

6. Create logic to populate the Quick Facts Bar. You may want to use generics for this.

7. Create a feature such that a user can convert metric units (meters) to British units (inches) with a tap of a button.

8. Create a feature such that a user can input an exchange rate in a text field and then convert between Galactic Credits and US Dollars.

9. Add error handling which include, but not limited to:
    * The device going offline when an API call is in progress
    * A user entering a 0 or negative exchange rate
    * An error resulting from a key or element missing from the JSON returned from the API

### Extra Credit

  * When a person is selected, all (if any) associated vehicles and starships are listed as well
  * All the data returned from the API is used to populate the picker, not just the first page of returned data
