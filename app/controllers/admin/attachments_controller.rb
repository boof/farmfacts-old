class Admin::AttachmentsController < Admin::Base
  DEFAULT_TYPE = 'Attachment'

  def create
    if valid_type?
      polymorphism    = AttachmentPolymorphism.new self
      attachment      = polymorphism.proxy.new params[:attachment]
      attachment.type = params[:type] unless default_type?
      attachment.save
    end

    return_or_redirect_to admin_dashboard_path
  end

  def bulk
    Attachment.bulk_methods.include? params[:bulk_action] and
    Attachment.send params[:bulk_action], params[:attachment_ids], params

    return_or_redirect_to admin_dashboard_path
  end

  protected
  def valid_type?
    ATTACHMENT_TYPES.include? params[:type]
  end
  def default_type?
    DEFAULT_TYPE.eql? params[:type]
  end

end
