class Author < ActiveRecord::Base
	has_many :books
	has_many :genres, through: :books

	def slug
		if name.present?
			name.downcase.gsub(' ', '-') 
		end
	end

	def self.find_by_slug(slug)
		Author.all.find{ |author| author.slug == slug }
	end

end