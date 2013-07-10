class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all 

    can :manage, :all if user.system_permission == 'administrator'
    
    can :update, ClearCMS::User, :id => user.id
  
    can :read, ClearCMS::Content if user.system_permission == 'editor'
    
    can :manage, ClearCMS::Asset #if user.system_permission == 'editor' #ability to upload images using async widget
    
    can :update, ClearCMS::Content, :assignee_id => user.id 
    
    #can :manage, :all if user[:email]=='josh@coolhunting.com'
    #can :manage, :all if user[:email]=='joel@coolhunting.com'
    #can :manage, :all if user[:email]=='kristin.breivik@gmail.com'
    
    
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
