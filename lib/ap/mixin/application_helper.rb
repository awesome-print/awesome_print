module ApplicationHelper
  def ap_debug(obj)
    content_tag(:pre, obj.ai(:plain => true), :class => 'debug_dump')
  end
end
