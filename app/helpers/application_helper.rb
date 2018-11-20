module ApplicationHelper
  def flash_class(level)
    case level
        when 'notice' then "alert alert-info"
        when 'success' then "alert alert-success"
        when 'error' then "alert alert-danger"
        when 'alert' then "alert alert-error"
        else "alert alert-info"
    end
  end

  def nav_link_to(text, path, active)
    active_link_to text,
      path,
      active: active,
      wrap_tag: :li,
      wrap_class: 'nav-item',
      class: 'nav-link'
  end
end
