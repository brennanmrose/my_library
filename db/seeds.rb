coelho = Author.create(first_name: 'Paulo', last_name: 'Coelho')
alchemist = Book.new(title: 'The Alchemist', author: coelho)
alchemist.genres.build(name: 'Fiction')
alchemist.save

tolkien = Author.create(first_name: 'J.R.R.', last_name: 'Tolkien')
lord_of_the_rings = Book.new(title: 'The Lord of the Rings', author: tolkien)
lord_of_the_rings.genres.build(name: 'Sci-Fi')
lord_of_the_rings.genres.build(name: 'Fantasy')
lord_of_the_rings.save

hurston = Author.create(first_name: 'Zora Neale', last_name: 'Hurston')
eyes_watching_god = Book.new(title: 'Their Eyes Were Watching God', author: hurston)
eyes_watching_god.genres.build(name: 'Classic')
eyes_watching_god.save