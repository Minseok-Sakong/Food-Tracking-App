**Rest API Documentation - FDA API**
----
  Return JSON data for a single food item barcode.
* **URL**

  /fdc/v1/foods/search
  
* **Method:**

  `POST`
  
*  **URL Params**

   **Required:**
 
   `query=[string]`

   **Optional:**
 
   None

* **Data Params**

  None

* **Success Response Example:**
  
  Food description of matched search term

  * **Code:** 200 <br />
    **Content:** `[
  {
    "foodSearchCriteria": {},
    "totalHits": 1034,
    "currentPage": 0,
    "totalPages": 0,
    "foods": [
      {
        "fdcId": 45001529,
        "dataType": "Branded",
        "description": "BROCCOLI",
        "foodCode": "string",
        "foodNutrients": [
          {
            "number": 303,
            "name": "Iron, Fe",
            "amount": 0.53,
            "unitName": "mg",
            "derivationCode": "LCCD",
            "derivationDescription": "Calculated from a daily value percentage per serving size measure"
          }
        ],
        "publicationDate": "4/1/2019",
        "scientificName": "string",
        "brandOwner": "Supervalu, Inc.",
        "gtinUpc": "041303020937",
        "ingredients": "string",
        "ndbNumber": "string",
        "additionalDescriptions": "Coon; sharp cheese; Tillamook; Hoop; Pioneer; New York; Wisconsin; Longhorn",
        "allHighlightFields": "string",
        "score": 0
      }
    ]
  }`
 
* **Error Response Example:**

  * **Code:** 403 FORBIDDEN <br />
    **Content:** `{
  "error": {
    "code": "API_KEY_MISSING",
    "message": "No api_key was supplied. Get one at https://api.nal.usda.gov:443"
  }
}`

* **Sample Call:**

    curl -X POST "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=K9C4dtMFuLkjMk0GXA9RRp4j7A5i4BagdxWfZAmv" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"query\":\"011210009301\"}"
