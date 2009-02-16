class Admin::AttachmentsController < Admin::Base

  def create
    attachment = AttachmentPolymorphism.new(self).proxy.new params[:attachment]
    attachment.type = params[:type] unless params[:type].blank?
    attachment.save

    return_or_redirect_to root_path
  end

  def bulk
    Attachment.bulk_methods.include? params[:bulk_action] and
    Attachment.send params[:bulk_action], params[:attachment_ids], params

    return_or_redirect_to root_path
  end

end
