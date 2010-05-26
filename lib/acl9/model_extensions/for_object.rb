module Acl9
  module ModelExtensions
    module ForObject
      def self.included(base)
          base.extend(ClassMethods)
      end
      module ClassMethods
        def find_by_role(role_name, user_id)
          self.find(:all, :joins => "inner join roles on authorizable_id = "+class_name.constantize.table_name+".id inner join roles_users on role_id=roles.id", :conditions => ["roles.name=? AND Authorizable_type = '"+class_name+"' AND roles_users.user_id=?",role_name.to_s, user_id])
        end
      end

      ##
      # Role check.
      #
      # @return [Boolean] Returns true if +subject+ has a role +role_name+ on this object.
      #
      # @param [Symbol,String] role_name Role name
      # @param [Subject] subject Subject to add role for
      # @see Acl9::ModelExtensions::Subject#has_role?
      def accepts_role?(role_name, subject)
        subject.has_role? role_name, self
      end

      ##
      # Add role on the object to specified subject.
      #
      # @param [Symbol,String] role_name Role name
      # @param [Subject] subject Subject to add role for
      # @see Acl9::ModelExtensions::Subject#has_role!
      def accepts_role!(role_name, subject)
        subject.has_role! role_name, self
      end

      ##
      # Free specified subject of a role on this object.
      #
      # @param [Symbol,String] role_name Role name
      # @param [Subject] subject Subject to remove role from
      # @see Acl9::ModelExtensions::Subject#has_no_role!
      def accepts_no_role!(role_name, subject)
        subject.has_no_role! role_name, self
      end

      ##
      # Are there any roles for the specified +subject+ on this object?
      #
      # @param [Subject] subject Subject to query roles
      # @return [Boolean] Returns true if +subject+ has any roles on this object.
      # @see Acl9::ModelExtensions::Subject#has_roles_for?
      def accepts_roles_by?(subject)
        subject.has_roles_for? self
      end

      alias :accepts_role_by? :accepts_roles_by?

      ##
      # Which roles does +subject+ have on this object?
      #
      # @return [Array<Role>] Role instances, associated both with +subject+ and +object+
      # @param [Subject] subject Subject to query roles
      # @see Acl9::ModelExtensions::Subject#roles_for
      def accepted_roles_by(subject)
        subject.roles_for self
      end
    end
  end
end
