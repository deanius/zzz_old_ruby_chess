# Holds the children in an assocation, and ensures children have reference back to parent
class AssociationStore < Array
  
  #the parent object instance holding a reference to this store
  attr_accessor :parent
  
  def initialize
    super
  end
  
  # appends the child if it passses validation, sets an association on it back to the parent
  # and saves it
  def << (child)
    unless child.kind_of? ActiveRecord::Base
      logger.error "Can only add instances of ActiveRecord::Base to a mock association"
      return
    end
    
    #set the reference to the parent
    # and not generic enough for AssociationStore but it helps my Chess test suite for now

    #todo deal with compound words and namespaces better
    ref_to_parent = parent.class.name.split('::').last.downcase 
    child.send( "#{ref_to_parent}=", @parent ) #if child.respond_to? "#{ref_to_parent}="
    
    logger.info "Added #{child} to association"
    
    #TODO refactor to include save functionality
    
    #do validation since ActiveRecord does on appending an object to an association
    child.do_validate
    super if child.valid?

    child.save #follows same pattern of calling before/after callbacks as does validation
    
  end
end