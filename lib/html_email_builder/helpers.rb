require 'active_support/core_ext/hash/keys' # for Hash#symbolize_keys

module Haml

  module Helpers

    # Creates a new layout container of rows & columns. Analogous to the <table> tag.
    # Defaults to centered and 100% width.
    # Example: = table(:width => 590) do
    def container(attrs = {}, &block)
      attrs.symbolize_keys!
      attrs[:cellpadding] ||= 0
      attrs[:cellspacing] ||= 0
      attrs[:border]      ||= 0
      attrs[:align]       ||= "center"
      attrs[:width]       ||= "100%"
      attrs[:style]       ||= "margin-left: auto; margin-right: auto;"

      capture_haml do
        haml_tag(:table, attrs) do
          if block
            block_output = capture_haml(&block)
            if has_row?(block_output)
              haml_concat(block_output)
            else
              # Use block_output rather than re-processing the block
              #   (especially because there will have been side effects).
              haml_concat row() { haml_concat(block_output) }
            end
          else
            haml_concat row()
          end
        end
      end
    end

    # Creates a new row inside a layout container. Analogous to the <tr> tag.
    # You are allowed to have a content block inside a row spacer, though it's not the common use case.
    # :spacer or :vspace -- vertical space
    # :hspace -- horizontal space
    # :colspan and :rowspan -- like for TD
    def row(attrs = {}, &block)
      attrs.symbolize_keys!

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

      capture_haml do
        haml_tag(:tr, attrs) do
          if block
            block_output = capture_haml(&block)
            if has_col?(block_output)
              haml_concat(block_output)
            else
              # Use block_output rather than re-processing the block
              #   (especially because there will have been side effects).
              haml_concat col(col_attrs) { haml_concat(block_output) }
            end
          else
            haml_concat col(col_attrs)
          end
        end
      end
    end

    # Creates a new column inside a layout container. Analogous to the <td> tag.
    # You are allowed to have a content block inside a column spacer, though it's not the common use case.
    # :vspace -- vertical space
    # :spacer or :hspace -- horizontal space
    def col(attrs = {}, &block)
      attrs.symbolize_keys!

      # Make sure the style attribute can be easily added to.
      attrs[:style] = add_semicolon(attrs[:style]) unless attrs[:style].nil?

      # Initialize width and height attributes.
      attrs[:width]  = nil
      attrs[:height] = nil

      # Set width and height based on other parameters.
      map_attrib!(attrs, :spacer, :width)
      map_attrib!(attrs, :hspace, :width)
      map_attrib!(attrs, :vspace, :height)
      attrs[:style] = attrs[:style].to_s + "width: #{attrs[:width]}px;"   unless attrs[:width].nil?
      attrs[:style] = attrs[:style].to_s + "height: #{attrs[:height]}px;" unless attrs[:height].nil?

      capture_haml do
        haml_tag(:td, attrs) do
          block.call if block
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
      str =~ /\A\s*<td\b/i
    end

    # Checks if an HTML string contains a row child element.
    def has_row?(str)
      str =~ /\A\s*<(tr|thead|tbody|tfoot)\b/i
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
