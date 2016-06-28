class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
       user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
    
      if user.user_type=="admin"
         can :manage, :all
        if $plan_active== true
          can :manage, :all
        else
          can :manage, Charge
        end
      elsif user.user_type == "user"
        client_properties=client_property(user)
        if client_properties== "read"
          can :read, Property
          can :read, Client
        elsif client_properties== "read_write" 
          can [:read, :update, :create], Client
          can [:read, :update, :create], Property
        elsif client_properties=="read_write_delete"
          can :manage, Client
          can :manage, Property
        else

        end 

        jobs_permission=job_permission(user)
        if jobs_permission =="read"
          can [:read,:work], :all
        elsif jobs_permission == "read_write"
          can [:read, :update, :create,:work], :all
          can [:read, :update, :create], Client
          can [:read, :update, :create], Property
        elsif jobs_permission == "read_write_delete"
          can :manage, :all
          can [:read, :update, :create], Client
          can [:read, :update, :create], Property
        else
        end

        quotes_permission=quote_permission(user)
        if quotes_permission =="read"
          can :read, Quote
          can :work, :all
        elsif quotes_permission == "read_write"
          can [:read, :update, :create], Quote
          can [:read, :update, :create], Client
          can [:read, :update, :create], Property
          can :work, :all
        elsif quotes_permission == "read_write_delete"
          can :work, :all
          can [:read, :update, :create], Client
          can [:read, :update, :create], Property
          can :manage, Quote
        end

        invoices_permission=invoice_permission(user)
        if invoices_permission =="read"
          can :read, :all
          can :work, :all
        elsif invoices_permission == "read_write"
          can [:read, :update, :create], :all
          can :work, :all
          can [:read, :update, :create], Client
          can [:read, :update, :create], Property
        elsif invoices_permission == "read_write_delete"
          can :manage, :all
          can :work, :all
          can [:read, :update, :create], Client
          can [:read, :update, :create], Property
        else
        end

        attachments_permission= attachment_permission(user)
        if attachments_permission =="read"
          can :read, Attachment
        elsif attachments_permission == "read_write"
          can [:read, :client_image_upload,:update_note], Client
          can [:read, :quote_image_upload], Quote
          can [:read, :job_image_upload], Job
          can [:read, :invoice_image_upload], Invoice

        elsif attachments_permission == "read_write_delete"
          can [:read, :client_image_upload,:update_note,:note_destroy], Client
          can [:read, :quote_image_upload], Quote
          can [:read, :job_image_upload], Job
          can [:read, :invoice_image_upload], Invoice
        else
        end

      end    
  end

  def client_property(user)
    @team = TeamMember.find_by_member_id(user.id)
    if @team.permission.permission_client_properties.count == 2
      if @team.permission.permission_client_properties.first.to_i==1
        return "read"
      elsif @team.permission.permission_client_properties.first.to_i==2
        return "read_write"
      else
        return "read_write_delete"
      end  
    end
  end

  def quote_permission(user)
    @team = TeamMember.find_by_member_id(user.id)
    if @team.permission.permission_quotes.count == 2
      if @team.permission.permission_quotes.first.to_i==1
        return "read"
      elsif @team.permission.permission_quotes.first.to_i==2
        return "read_write"
      else
        return "read_write_delete"
      end  
    end
  end

  def job_permission(user)
    @team = TeamMember.find_by_member_id(user.id)
    if @team.permission.permission_jobs.count == 2
      if @team.permission.permission_jobs.first.to_i==1
        return "read"
      elsif @team.permission.permission_jobs.first.to_i==2
        return "read_write"
      else
        return "read_write_delete"
      end  
    end
  end

  def invoice_permission(user)
    @team = TeamMember.find_by_member_id(user.id)
    if @team.permission.permission_invoices.count == 2
      if @team.permission.permission_invoices.first.to_i==1
        return "read"
      elsif @team.permission.permission_invoices.first.to_i==2
        return "read_write"
      else
        return "read_write_delete"
      end  
    end
  end

  def attachment_permission(user)
    @team = TeamMember.find_by_member_id(user.id)
    if @team.permission.permission_note_attachment.count == 2
      if @team.permission.permission_note_attachment.second.to_i==1
        return "read"
      elsif @team.permission.permission_note_attachment.second.to_i==2
        return "read_write"
      elsif @team.permission.permission_note_attachment.second.to_i==3
        return "read_write_delete"
      end  
    end
  end

end
