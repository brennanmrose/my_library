class Genre < ActiveRecord::Base
	has_many :book_genres
	has_many :books, through: :book_genres
	has_many :authors, through: :books 

	def slug
		if name.present?
			name.downcase.gsub(' ', '-') 
		end
	end

	def self.find_by_slug(slug)
		Genre.all.find{ |song| song.slug == slug }
	end

end