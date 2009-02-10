class Admin::AttachmentsController < Admin::Base
  class AttachmentPolymorphism < Polymorphism; end

  def create
    AttachmentPolymorphism.new(self).proxy.create params[:attachment]
    return_or_redirect_to root_path
  end

  def bulk
    Attachment.bulk_methods.include? params[:bulk_action] and
    Attachment.send params[:bulk_action], params[:attachment_ids], params

    return_or_redirect_to root_path
  end

end
