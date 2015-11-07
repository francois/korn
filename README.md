# Korn

Korn is a data mapper from Hash to data model. Korn maps the messy HTTP forms world into nice and clean object models.

## Usage

```ruby
require "korn/form"

class CategoryForm < Korn::Form
  # Map a "code" property from the HTTP params into the accessor named "category_code="
  property :code, :category_code

  # Map an "id" property from the HTTP params into the accessor named "id="
  # Coerce this value to an Integer
  property :id, Integer

  # Map the "valid_on" property, coercing to a Date object when copying
  # to the model, if necessary
  property :valid_starting_on, Date

  collection :names, ->{ CategoryName.new } do
    property :id, Integer
    property :lang
    property :name
  end

  collection :synonyms, ->{ CategorySynonym.new } do
    properties :id, Integer
    # Shortcut when multiple properties share the same options
    properties :lang, :name
  end
end

# In a Rails controller
class CategoriesController < ApplicationController
  def new
    @form = CategoryForm.new
  end

  def edit
    model = Category.find(params[:id])
    @form = CategoryForm.new
    @form.copy_from(model)

    # Shortcut API
    @form = CategoryForm[Category.find(params[:id])]
  end

  def create
    @form = CategoryForm.new(params[:category])
    if @form.valid? then
      model = @form.copy_to(Category.new)
      model.save!
      render_with @form
    else
      render
    end

    # Alternatively... using the shortcut API
    @form = CategoryForm[params[:category]] do |form|
      # The form is guaranteed valid here
      form.copy_to(Category.new).save!

      # Make sure to never leave the block if you don't want to
      # generate DoubleRender errors!
      return render_with form
    end

    # else, validation failed and we need to redisplay the form
    render
  end
end
```

## Explicitness

This library aims to be very explicit: everything is exposed; magic is reduced to an absolute minimum, and only where it makes sense (the `#[]` shortcut API for instantiating a form and copying values).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'korn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install korn

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/korn. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

