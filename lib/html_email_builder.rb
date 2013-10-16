# module GTranslate
#   class Translator
#     def perform( text ); 'hola munda'; end
#   end

#   def self.translate( text )
#     t = Translator.new
#     t.perform( text )
#   end
# end

# TODO: go through email output with fine-tooth comb

module Haml
  # test: GiftCardMailer.recipient_notification(GiftCard.find(8)).deliver
  # test: OrderMailer.notify_email(Order.find(13)).deliver

  module Helpers
    @@seen_container = 0  # num of containers we've seen in the hierarchy
    @@seen_row       = 0  # num of rows. Note: rows cannot be nested, so max is 1

    # Creates a new layout container of rows & columns. Analogous to the <table> tag.
    # Defaults to centered and 100% width.
    # Example: = table(:width => 590) do
    def container(attrs = {}, &block)
      puts "  " * @@seen_container + "container() #{attrs}"
      @@seen_container += 1
      @@seen_row = 0

      attrs.symbolize_keys!
      attrs[:cellpadding] ||= 0
      attrs[:cellspacing] ||= 0
      attrs[:border]      ||= 0
      attrs[:align]       ||= "center"
      attrs[:width]       ||= "100%"
      attrs[:style]       ||= "margin-left: auto; margin-right: auto;"

      output = capture_haml do
        haml_tag(:table, attrs) do
          block.call
        end
      end

      @@seen_container -= 1
      return output
    end

    # Creates a new row inside a layout container. Analogous to the <tr> tag.
    # You are allowed to have a content block inside a row spacer, though it's not the common use case.
    # :spacer or :vspace -- vertical space
    # :hspace -- horizontal space
    # :colspan and :rowspan -- like for TD
    def row(attrs = {}, colAttrs = {}, &block)
      puts "  " * @@seen_container + "row() #{attrs} colAttrs #{colAttrs}"
      @@seen_row += 1
      attrs.symbolize_keys!

      # Check that we are inside a container.
      raise "row() with no parent container()" if @@seen_container.zero?

      # Define and initialize column attributes.
      # These attributes are passed to the child col(s), and ignored for the row.
      col_attrs = {
        :vspace  => nil,
        :hspace  => nil,
        :rowspan => nil,
        :colspan => nil
      }

      # Handle the :spacer attribute.
      map_attrib!(attrs, :spacer, :vspace)
      attrs.delete(:spacer)

      # Move column parameters into that hash.
      col_attrs.each_key do |key|
        unless attrs[key].nil?
          col_attrs[key] = attrs[key]
          attrs.delete(key)
        end
      end

      # Merge in any specified attributes for the column.
      col_attrs.merge!(colAttrs)

      output = capture_haml do
        haml_tag(:tr, attrs) do
          if block
            block_output = capture_haml(&block)
            puts "  " * @@seen_container + "  checking if \"#{block_output[0..20]}\" has child..."
            if has_col?(block_output)
              puts "yep"
              haml_concat(block_output)
            else
              puts "nope"
              # Use block_output rather than re-processing the block
              #   (especially because there will have been side effects).
              haml_concat col(col_attrs) { haml_concat(block_output) }
            end
          else
            haml_concat col(col_attrs)
          end
        end
      end

      @@seen_row -= 1
      return output
    end

    # Creates a new column inside a layout container. Analogous to the <td> tag.
    # You are allowed to have a content block inside a column spacer, though it's not the common use case.
    # :vspace -- vertical space
    # :spacer or :hspace -- horizontal space
    def col(attrs = {}, &block)
      puts "  " * @@seen_container + "col() #{attrs}"
      attrs.symbolize_keys!

      # Check that we are inside a container.
      raise "col() with no parent container()" if @@seen_container.zero?

      # Make sure the style attribute can be easily added to.
      attrs[:style] = add_semicolon(attrs[:style]) unless attrs[:style].nil?

      # Initialize width and height attributes.
      attrs[:width]  = nil
      attrs[:height] = nil

      # Set width and height based on other parameters.
      map_attrib!(attrs, :spacer, :width)
      map_attrib!(attrs, :hspace, :width)
      map_attrib!(attrs, :vspace, :height)
      attrs[:style] = attrs[:style].to_s + "width:  #{attrs[:width]}px;"  unless attrs[:width].nil?
      attrs[:style] = attrs[:style].to_s + "height: #{attrs[:height]}px;" unless attrs[:height].nil?

      capture_haml do
        if @@seen_row.nonzero?
          haml_tag(:td, attrs) do
            block.call if block
          end
        else
          haml_concat row({}, attrs, &block)
        end
      end
    end

    private

    # Appends a semicolon to a CSS style string to make it chainable.
    def add_semicolon(str)
      str = str.to_s
      if str[-1] != ";"
        str = str + ";"
      end
      return str
    end

    # Checks if an HTML string contains a column child element.
    def has_col?(str)
      result = (str =~ /\A\s*<td\b/i)
      puts "  " * @@seen_container + "  comparing \"#{str[0..20]}\" ... #{result.inspect}"
      return result
    end

    # Moves an integer value from one attribute to another.
    def map_attrib!(hash, old_key, new_key)
      unless hash[old_key].nil?
        hash[new_key] = hash[old_key].to_i
        hash.delete(old_key)
      end
    end

  end # Helpers module

end # Haml module
