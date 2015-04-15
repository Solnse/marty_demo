require 'marty/new_posting_form'
# posting_type/role mapping
Marty::NewPostingForm.class_eval do
  has_marty_permissions BASE: [:admin,:dev]
end
