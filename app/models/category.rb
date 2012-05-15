class Category < ActiveRecord::Base

  validates :category, :presence => true, :uniqueness => true
  
  has_many :groups

  #####################################################
  # CATEGORY ##########################################
  #####################################################

  # returns the primary_category
  def primary_category
    self.category.split("/").first
  end
  
  # returns the sub_category
  def sub_category
    self.category.split("/").second 
  end
  
  
  
  #####################################################
  # SUB-CATEGORIES ####################################
  #####################################################

  # gets a sub_category 
  # returns the groups in that category
  def self.groups(sub_category)
    Group.includes(:category).where("categories.category LIKE ?", "%#{sub_category}%")
  end


  #####################################################
  # PRIMARY-CATEGORIES ################################
  #####################################################


  # gets a primary_category
  # returns the pages for the groups in that category
  def self.primary_category_pages(primary_category)
    @categories = Category.sub_categories(primary_category)
    @categories.map(&:groups).flatten.map(&:most_recent_page).reject(&:nil?)
  end
  
  # returns the primary_categories
  def self.primary_categories
    Category.select("category").map(&:category).map {|c| c.split("/").first.try(:strip)}.uniq
  end
  
  # gets a primary_category
  # returns sub_categories
  def self.sub_categories(category)
    Category.where("category LIKE ?", "#{category}%")
  end
  

  #####################################################
  # STATISTICS ########################################
  #####################################################

  # calculate the number of pages for a category
  def num_pages
    groups = self.groups.includes(:descriptions)
    groups.map {|g| g.descriptions.length > 0 ? 1 : 0}.sum
  end
  
  # calculate the number of pages for all cateogries
  def self.num_added_pages
    descriptions = Description.includes(:group => :category)
    descriptions.group_by {|d| d.group.category}.map do |category, ds|
      num_descriptions = ds.group_by(&:group).keys.length
      {category => num_descriptions}
    end
  end

end
