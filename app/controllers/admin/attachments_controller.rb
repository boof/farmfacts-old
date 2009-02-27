class Admin::AttachmentsController < Admin::Base
  DEFAULT_TYPE = 'Attachment'

  def create
    @attachment.type = params[:type] unless default_type?
    @attachment.save

    return_or_redirect_to admin_dashboard_path
  end

  def bulk
    Attachment.bulk_methods.include? params[:bulk_action] and
    Attachment.send params[:bulk_action], params[:attachment_ids], params

    return_or_redirect_to admin_dashboard_path
  end

  def move_down
    @attachment.move_lower
    return_or_redirect_to admin_dashboard_path
  end
  def move_up
    @attachment.move_higher
    return_or_redirect_to admin_dashboard_path
  end

  protected
  def valid_type?
    ATTACHMENT_TYPES.any? { |t| t.last == params[:type] }
  end
  def default_type?
    DEFAULT_TYPE.eql? params[:type]
  end
  def assign_new_attachment
    @polymorphism = AttachmentPolymorphism.new self
    @attachment = @polymorphism.proxy.new params[:attachment]
  end
  def assign_attachment
    @polymorphism = AttachmentPolymorphism.new self
    @attachment = @polymorphism.proxy_target
  end
  
  def check_type
    valid_type? or return_or_redirect_to admin_dashboard_path
  end
  before_filter :check_type, :only => :create
  before_filter :assign_new_attachment, :only => :create
  before_filter :assign_attachment, :only => [:move_up, :move_down]

end
