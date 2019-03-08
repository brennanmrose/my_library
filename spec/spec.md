# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
		Used the Sinatra gem and Corneal gem to build application
- [X] Use ActiveRecord for storing information in a database
		See config/environment.rb where Active Record connects the app to the database using SQLite3
- [X] Include more than one model class (e.g. User, Post, Category)
		See app/models - includes User, Book, Author, Genre and BookGenre
- [X] Include at least one has_many relationship on your User model (e.g. User has_many Posts)
		User has many books, Author has many books and many genres through books, Book has many genres through book_genres, Genre has many books through book_genres and authors through books
- [X] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)
		Book belongs to User and Author
- [X] Include user accounts with unique login attribute (username or email)
		User has both username and email attributes
- [X] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
		User can create, read, update and delete any of their books. User can also create, read update their own account.
- [X] Ensure that users can't modify content created by other users
		Users are unable to modify content created by other users through validations
- [X] Include user input validations
		Users cannot create a new book without providing a title, author and genre. They may also not create a book that already exists.
- [ ] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
		In progress
- [X] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code
		See README.md and LICENSE.md
Confirm
- [X] You have a large number of small Git commits
		There have been 102 commits to date
- [X] Your commit messages are meaningful
		Commit messages are meaningful
- [X] You made the changes in a commit that relate to the commit message
		This is correct
- [X] You don't include changes in a commit that aren't related to the commit message
		It was intended not to do so but some may have slipped through before I was aware of this guideline. Since becoming aware all commit messages are only scoped to the changes made on the commit.