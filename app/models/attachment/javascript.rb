class Attachment::Javascript < Attachment

  module Extension
    def to_s
      %Q'<script type="text/javascript" src="#{ attachable }"></script>'
    end
  end
  include Extension

end
