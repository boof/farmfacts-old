module Bulk::Onlist
  extend Bulk

  def bulk_accept(ids, *args)
    transaction do
      [*find(ids)].all? do |record|
        record.onlist.accept
        record.accepted?
      end or raise ActiveRecord::Rollback
    end unless ids.blank?
  end
  alias_method :bulk_publish, :bulk_accept
  alias_method :bulk_show, :bulk_accept
  def bulk_reject(ids, *args)
    transaction do
      [*find(ids)].all? do |record|
        record.onlist.reject
        record.rejected?
      end or raise ActiveRecord::Rollback
    end unless ids.blank?
  end
  alias_method :bulk_revoke, :bulk_reject
  alias_method :bulk_hide, :bulk_reject

end
