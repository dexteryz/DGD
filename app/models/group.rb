class Group < ActiveRecord::Base

  belongs_to :category
  has_many :descriptions

  has_many :group_execs
  has_many :users, :through => :group_execs
  
  def to_s
    name
  end
  
  def self.recently_updated(num)
    Description.all.sort_by { |d| d.updated_at }.reverse.map { |d| Group.find(d.group_id) }.uniq.take(num)
  end
  
  def self.find_by_description_id(id)
    Group.find(Description.find(id).group_id)
  end

end
