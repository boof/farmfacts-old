module Bulk

  def extended(base)
    base.instance_eval { attr_accessor :bulk_methods }

    base.bulk_methods ||= []
    base.bulk_methods += instance_methods
  end

end
