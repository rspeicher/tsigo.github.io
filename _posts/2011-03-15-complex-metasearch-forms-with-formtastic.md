---
title: "Complex MetaSearch forms with Formtastic"
categories: rails ruby formtastic meta_search
---

[meta_search](https://github.com/ernie/meta_search) lets you perform advanced
queries on your ActiveRecord models, and
[Formtastic](https://github.com/justinfrench/formtastic) helps in building
semantic forms quickly and easily.

Today I had need to build an advanced search form that would let the user
define a search where an attribute was **between** two values. For example,
finding users whose age is between 20 and 30.

MetaSearch defines the `multiparameter_field` form helper method, but getting
that helper to work with Formtastic required some doing:

First, define the `:between` where as described in the README:

```ruby
# config/initializers/meta_search.rb

MetaSearch::Where.add :between, :btw,
  :predicate => :in,
  :types => [:integer, :float, :decimal, :date, :datetime, :timestamp, :time],
  :formatter => Proc.new {|param| Range.new(param.first, param.last)},
  :validator => Proc.new {|param|
  param.is_a?(Array) && !(param[0].blank? || param[1].blank?)
}
```

Next, we need to define a custom form builder class:

```ruby
# config/initializers/multi_param_form_builder.rb

class MultiParamFormBuilder < Formtastic::SemanticFormBuilder
  # Allows <tt>:as => :between</tt> which utilizes MetaSearch's
  # <tt>multiparameter_field</tt> helper
  def between_input(method, options = {})
    input_options = options.delete(:input_html) || {}
    label_options = options_for_label(options)
    label_options[:for] ||= input_options[:id]

    label(method, label_options) <<
      multiparameter_field(method, {:field_type => :text_field},{:field_type => :text_field}, input_options)
  end
end
```

And then tell Formtastic to use it:

```ruby
# config/initializers/formtastic.rb

Formtastic::SemanticFormHelper.builder = MultiParamFormBuilder
```

Now in a view, use Formtastic and MetaSearch as normal, just tell Formtastic to
render the field as `:between`:

```ruby
# app/views/users/_search.html.haml

= semantic_form_for @search, :method => :post do |form|
  = form.inputs do
    = form.input :age_between, :as => :between
  = form.buttons do
    %button.button{:type => 'submit'} Search
```

And that's it!
