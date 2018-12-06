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

  def member_checkboxes(object_name, method, the_label, errors)
    render partial: 'shared/member_checkboxes', locals: {
      the_label: the_label,
      object_name: object_name,
      method: method,
      errors: errors
    }
  end

  def collection_check_boxes_columns(
    form_builder,
    object_method,
    collection,
    value_method,
    label_method,
    label_text: nil,
    columns: 3,
    errors: []
  )
    label_text = object_method.to_s.titleize if label_text.nil?
    render partial: 'shared/collection_checkboxes_columns', locals: {
      form_builder: form_builder,
      object_method: object_method,
      collection: collection,
      value_method: value_method,
      label_method: label_method,
      label_text: label_text,
      columns: columns,
      errors: errors
    }
  end
end
