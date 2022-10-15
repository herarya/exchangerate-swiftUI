
# Introduction

Welcome to currency exchange with SwiftUI+MVVM+COREDATA

<img src="https://github.com/herarya/exchangerate-swiftUI/blob/main/ss/1.png" width="150">
<img src="https://github.com/herarya/exchangerate-swiftUI/blob/main/ss/2.png" width="150">

<img src="https://github.com/herarya/exchangerate-swiftUI/blob/main/ss/ECA956FA-A78E-414B-8870-D37D52547774.gif" width="150">


# Folder Structure

The structure of each folder is explained below:

- `Model/` – The Model is the same layer we had in MVC and is used to encapsulate data and the business logic.
- `ModelView/` – The model does not directly communicate data with the view, instead it uses a reactive view to do so . The model tells the view Model about any changes made to the data, the view model will then “publish” these changes to the view
- `Network/` – contains Http Request
- `Services/` – contains services call with  local service or API request.
- `Utilities/` – contains extension / helper. 
- `View/` – contains main View with SwiftUI


# To-do

-  UI Unit test
-  Integration Unit test
-  CI/CD

# Author

Created by herman 
