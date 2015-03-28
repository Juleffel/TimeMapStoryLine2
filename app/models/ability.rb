class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can [:read, :update], :all
      can :manage, [Character, Answer, Category, Faction, Group, Link, 
        LinkNature, Presence, SpacetimePosition, User, RpStatus]
      can :manage, Topic do |topic|
        not topic.special_character
      end
    elsif !user.new_record?
      can :manage, Character, user_id: user.id
      can :read, :all
      can :graph, Link
      can :manage, Link, from_character: {user_id: user.id}
      can :create, Topic
      can :manage, Topic do |topic|
        topic.user_id == user.id and not topic.special_character
      end
      can :create, Answer
      can :manage, Answer do |answer|
        can?(:read, answer.topic) and (answer.user_id == user.id) and (not answer.character or answer.character.user_id == user.id)
      end
    else
      can :read, :all
      can :graph, Link
    end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
