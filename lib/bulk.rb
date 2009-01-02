module Bulk

  def extended(base)
    (class << base; self; end).module_eval { attr_accessor :bulk_methods }

    base.bulk_methods ||= []
    base.bulk_methods += instance_methods(false)
  end

end
