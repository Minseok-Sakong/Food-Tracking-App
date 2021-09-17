# EC463 Software Mini Project

#### By Minseok Sakong (msakong@bu.edu) and Marcel Aubry (aubryma@bu.edu)

## OBJECTIVES

- Create a full stack, cross-platform mobile application 
- Use FDC API REST service to obtain calorie information of ingredients based off their barcodes
- Have the user enter Gmail authentication to save recipes to their respective accounts
- Store and manage data under Google Firebase
- Follow agile software development throughout the duration of the project

## DESIGN
### Front End

- User is prompted with a login screen that uses Gmail authentication to store data in their respective account
- Once access is granted, the user can select to scan a barcode or view their saved recipes
- When the scanner successfully scans the item, the user sees its calorie information
- From there, the user is asked the amount of portions and can either add it to a recipe or scan another item

### Back End

- When a barcode is scanned, its number is stored in a query object and posed to the FDC API
- The cURL command returns the information and is stored in an object which is then added to that user's database
- The item is also added to a recipe if the user decides to do so

## TESTING AND RESULTS

### Barcode Scanner

- The first test was to try out the barcode scanner 
- To do this, we loaded the application onto our Android phone and used its camera to scan a Gatorade bottle
- The application successfully recognized the barcode and save its number as a string

### API Calls from the Application

- Once we had the barcode number saved as a string, our next test was to load it into our query object and execute a cURL command
- The API returned the information requested 

### Firebase Storage

- Our next test was sending the acquired data to firebase and saving it within a user's collection
- The result was that once we pressed the button "Get", the item's information is sent to firebase
- Additionally, the data can be sent back upon request, for example when the user taps the "List Ingredients" button

### Gmail Account Login

- Through the creation of multiple pages, the Google account Login was implemented
- The result is that a user can now log in, access their respective data stored in their fire storage, and log out

## PICTURES AND VIDEOS OF FINAL PROJECT


