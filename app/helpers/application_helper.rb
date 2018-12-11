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

  def dropdown_nav(name, id, active_regex, links=[])
    nav_class = "nav-item dropdown"
    is_active = is_active_link?(request.env['PATH_INFO'], active_regex)
    nav_class << " active" if is_active

    render partial:  'layouts/nav_dropdown',
      locals: {
        name: name,
        id: id,
        links: links,
        nav_item_class: nav_class
      }
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def meetings_dropdown_links
    links = [ { name: 'Search Meetings', path: meetings_path } ]
    if is_secretary? || is_admin?
      links << { name: 'Create New Meeting', path: new_meeting_path }
    end
  end
end
