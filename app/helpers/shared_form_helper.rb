module SharedFormHelper
  def form_entry(the_label, the_input)
    render partial: 'shared/form_field', locals: {
      the_label: the_label,
      the_input: the_input,
    }
  end

  def submit(text)
    render partial: 'shared/form_submit', locals: {
      text: text
    }
  end

  def label_class(object_name, method, text = nil, options = {})
    options[:class] = 'col-sm-2 col-form-label'
    label(object_name, method, text, options)
  end

  def member_checkboxes(object_name, method, the_label)
    render partial: 'shared/member_checkboxes', locals: {
      the_label: the_label,
      object_name: object_name,
      method: method
    }
  end
end
