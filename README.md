# EC463 Software Mini Project

#### By Minseok Sakong (msakong@bu.edu) and Marcel Aubry (aubryma@bu.edu)

## OBJECTIVES

- Create a full stack, cross-platform mobile application 
- Use FDC API REST service to obtain calorie information of ingredients based off their barcodes
- Have the user enter Gmail authentication to save recipes to their respective accounts
- Store and manage data under Google Firebase
- Follow agile software development throughout the duration of the project

## Design
### Front End

- User is prompted with a login screen that uses Gmail authentication to store data in their respective account
- Once access is granted, the user can select to scan a barcode or view their saved recipes
- When the scanner successfully scans the item, the user sees its calorie information
- From there, the user is asked the amount of portions and can either add it to a recipe or scan another item

### Back End

- When a barcode is scanned, its number is stored in a query object and posed to the FDC API
- The cURL command returns the information and is stored in an object which is then added to that users database
- The item is also added to a recipe if the user decides to do so



A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
