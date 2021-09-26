# products_test_app

A simple products app using an rest API Flask-App
[source code @github]
https://github.com/alfatihtalab/product_rest_api

3 tables in the database: users, product, order

adding user
https://products-flutter-rest-api.herokuapp.com/user
method = ['POST'] with JSON {"id": "id"}

adding product
https://products-flutter-rest-api.herokuapp.com/product
method = ['POST'] with JSON {"id": id, "name": "name", "price": "price", url: "url"}
header: ["Content-Type": "application/json"]



1. This app used IMEI code of device, as user ID to write it into the database.
2. Fetching all product in the database using Future, Async, Await
3. Posting orders to the database belongs to the user ID
4. Pet all the orders belongs to the user ID


additional packages used:

unique_identifier: ^0.2.0
http: ^0.13.3
fluttertoast: ^8.0.8