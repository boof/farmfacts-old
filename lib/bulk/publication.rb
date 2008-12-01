module Bulk::Publication
#  extend Bulk

  def bulk_publish(ids, *args)
    transaction do
      find(ids).all? do |record|
        record.onlist.accept unless record.accepted?
        record.accepted?
      end or raise ActiveRecord::Rollback
    end unless ids.blank?
  end
  def bulk_revoke(ids, *args)
    transaction do
      find(ids).all? do |record|
        record.onlist.reject unless record.rejected?
        record.rejected?
      end or raise ActiveRecord::Rollback
    end unless ids.blank?
  end

end
