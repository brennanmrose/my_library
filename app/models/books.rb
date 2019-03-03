class Book < ActiveRecord::Base
	belongs_to :author
	belongs_to :user
	has_many :book_genres
	has_many :genres, through: :book_genres

	def slug
		if title.present?
			title.downcase.gsub(' ', '-') 
		end
	end

	def self.find_by_slug(slug)
		Book.all.find{ |song| song.slug == slug }
	end
	
end