class Attachment::Javascript < Attachment

  def to_s
    %Q'<script type="text/javascript" src="#{ attachable }"></script>'
  end

end
