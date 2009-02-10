class Admin::AttachmentsController < Admin::Base
  class AttachmentPolymorphism < Polymorphism; end

  def create
    AttachmentPolymorphism.new(self).proxy.create params[:attachment]
    redirect_to params[:return_to]
  end

  def bulk
    Attachment.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Attachment,
      params[:attachment_ids], params

    redirect_to params[:return_to]
  end

end
