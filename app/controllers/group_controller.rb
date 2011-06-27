class GroupController < ActionController::Base
  layout 'application'
  before_filter :load_group_hash
  
  def index
    @categories = Category.includes(:groups).find(:all)
    
    # sort the categories and groups
    @categories.sort_by!(&:category)
    @categories.each {|c| c.groups.sort_by!(&:name)}
    
  end
  
  def show
    @group = Group.includes(:descriptions).find(params[:id])
    @description = @group.descriptions.order("created_at DESC").first
    if (!@description.presence)
      @description = Description.new
      @description.description = Description.default_description
    end
  end
  
  def leaderboard
  end
  
  def recently_updated
  end
  
  def least_updated
  end
  
  private
  def load_group_hash
    @group_hash = Group.all.map {|g| {:label => g.name, :value => g.name, :id => g.id}}
  end
end

