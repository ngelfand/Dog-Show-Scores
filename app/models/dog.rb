class Dog < ActiveRecord::Base
  attr_accessible :akc_id, :akc_name, :owner, :breed
  validates :akc_name, :presence => true
  validates :akc_id, :presence => true,
                     :uniqueness => true
  has_many :obedscores
  has_many :shows, :through => :obedscores
   
  def self.search(type, search, page)
    search_type = "lower(#{type}) LIKE ?"
    search_value = "%" + search.downcase + "%"
    paginate(:page=>page, :conditions => [search_type, search_value])
  end
  
  # Find all dogs of a given breed that have a given title.
  # The right way to do this, is to strip title from the dog's name, store them
  # all as a separate column and search through it. But since AKC won't let me
  # have just the registered name AND they have five zillions titles with numbers
  # in them (what the hell is HSAs?), we'll just cheat. First do an approximate
  # search in the database and then filter the results using a regular expression
  # Titles that we surrently support: CD CDX UD UDX OTCH RN RA RE RAE
  
  def self.find_by_breed_and_title(breed, title)
    # some special cases to include only CD (not CDX), UD (not UDX), and RE (not RAE)
    rawdogs = nil
    if (title == "CD")
      rawdogs = Dog.find(:all, :conditions => ["lower(breed) LIKE ? and akc_name LIKE ? and akc_name not LIKE ?", "%#{breed}%", "% CD%", "%CDX%"])
    elsif (title == "UD")
      rawdogs = Dog.find(:all, :conditions => ["lower(breed) LIKE ? and akc_name LIKE ? and akc_name not LIKE ?", "%#{breed}%", "% UD%", "%UDX%"])
    elsif (title == "RE")
      rawdogs = Dog.find(:all, :conditions => ["lower(breed) LIKE ? and akc_name LIKE ? and akc_name not LIKE ?", "%#{breed}%", "% RE%", "%RAE%"])
    elsif (title == "OTCH")
      # OTCH goes in front
      rawdogs =  Dog.find(:all, :conditions => ["lower(breed) LIKE ? and akc_name LIKE ?", "%#{breed}%", "%#{title} %"])
    else
      rawdogs = Dog.find(:all, :conditions => ["lower(breed) LIKE ? and akc_name LIKE ?", "%#{breed}%", "% #{title}%"])
    end
    
    # now, we want to make sure that the titles are not part of the name so they should be surrounded either by 
    # whitespace, beginning of line, newline, or followed by a number (UDX2 etc)
    @dogs = rawdogs
  end
end
