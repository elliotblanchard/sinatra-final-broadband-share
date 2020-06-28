# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app 
- [x] Use ActiveRecord for storing information in a database
- [x] Include more than one model class (e.g. User, Post, Category) - has models for Admin, Contract, Provider, and Student
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts) - Provider has_many Contracts
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User) - A Contract belongs_to a Provider
- [x] Include user accounts with unique login attribute (username or email) - User accounts for Providers and Students (and Admin)
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying - Provider has full CRUD on their Contracts. IN ADDITION, any Student in range on a Contract can rate it.
- [x] Ensure that users can't modify content created by other users - I check session hash to restrict access to Contracts, Students, and Providers to only the correct users - for security and privacy
- [x] Include user input validations - Extensive Active Record, address, and REGEX validation
- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new) - Plenty of status and error flash messages
- [ ] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message