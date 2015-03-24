# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

=begin
HTML::WhiteListSanitizer.allowed_tags = ['strong', 'em', 'b', 'i', 'u', 'blockquote', 'span', 'p', 'div', 'table', 'tr', 'th', 'td', 'a', 'img']
HTML::WhiteListSanitizer.allowed_attributes = ['href', 'title', 'alt', 'src']
# ALLOWED CSS PROPERTIES 
HTML::WhiteListSanitizer.allowed_css_properties = Set.new(%w(text-align font-weight text-decoration font-style color))
# ALLOWED CSS PROPERTIES - acts like property_name-*, for example `text` allows text-align, text-deco...
HTML::WhiteListSanitizer.shorthand_css_properties = Set.new(%w())
#HTML::WhiteListSanitizer.
=end