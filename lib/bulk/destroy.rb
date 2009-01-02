module Bulk::Destroy
  extend Bulk

  def bulk_destroy(ids, *args)
    transaction do
      find(ids).all? { |record| record.destroy } or
      raise ActiveRecord::Rollback
    end unless ids.blank?
  end

end
