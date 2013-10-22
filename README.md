# HTML Email Builder

> The easy way to create HTML emails in Rails.

This Ruby gem is a collection of helpers for creating HTML emails, using best practices.

* Haml helpers for easily constructing table-based layouts

## Requirements

* Ruby 1.8.7+
* Haml 3.2/4.0+ (if you want to use the layout helpers)

## Installation

Add this line to your application's Gemfile:

    gem 'html_email_builder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html_email_builder

## Usage

In Rails, you can add the helpers to ActionMailer in `config/initializers/action_mailer.rb`:

```ruby
class ActionMailer::Base
  add_template_helper(HtmlEmailBuilder)
end
```

### Haml Layout Helpers

In your Haml, you can now use `container` to define a new layout. Its children `row` and `col`, are used to construct the rows and columns:

```haml
= container do
  = row do
    = col do
      Column 1
    = col do
      Column 2
```

These helpers directly translate into `<table>`, `<tr>`, and `<td>`, so you'll need to take care that your columns in each row within a `container` are equal, just like in HTML. Like HTML tables, containers can be nested.

By default, containers fill the width of their parent and are centered horizontally.

All helpers accept HTML attributes:

```haml
= container(:width => 590) do
  = row do
    = col(:colspan => 2, :style => "text-align: right;") do
      Column
```

They can also be empty:

```haml
= container do
  = row do
    -# translates to empty TD
    = col
```

The `spacer`, `vspace`, and `hspace` attributes tell a row or column to act as padding between its siblings. The `spacer` attribute defaults to horizontal space for columns and vertical space for rows; `vspace` and `hspace` specify which type of spacing to use.

```haml
= container do
  = row do
    -# 5px wide (horizontal) space
    = col(:spacer => 5)
    -# same as :spacer => 5
    = col(:hspace => 5)
    -# 5px tall (vertical) space
    = col(:vspace => 5)

  -# 5px tall (vertical) space
  = row(:spacer => 5)

  -# 5px wide (horizontal) space
  = row(:hspace => 5)

  -# same as :spacer => 5
  = row(:vspace => 5)
```

The `rowspan` and `colspan` HTML attributes can be defined on a `row`; they are simply passed to its child(ren):

```haml
= container do
  = row do
    = col
    = col
    = col
  = row(:colspan => 3)
    = col
```

Finally, `row` and `col` elements can be omitted:

```haml
= container do
  -# row is implied
  = col
    Column 1
  = col
    Column 2
```

```haml
= container do
  = row
    -# col is implied
    Content goes here
```

or even:

```haml
= container do
  -# Both row and col are implied
  Content goes here
```

Check out [the complicated.haml test](test/haml/complicated.haml) for a full example.

## Contributing

Fixes and suggestions are welcome. If you have a bug report or feature suggestion, create a new issue in GitHub. Patches can be submitted as pull requests.

## Testing

Tested on Ruby 1.8.7 - 2.1.0-preview.

To run tests (make sure Rake is installed):

    $ rake test

To run Haml compatibility tests:

    $ rake test:hc

## Changelog

* 0.1.0 -- Initial release, with Haml helpers

## License

HTML Email Builder is released under the Apache 2.0 License. See the bundled [LICENSE.txt](LICENSE.txt) file for details.

## Thanks

* [htmlemailboilerplate.com](http://htmlemailboilerplate.com)
* [Campaign Monitor](http://www.campaignmonitor.com/resources/will-it-work/guidelines/)
