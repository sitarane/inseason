class HttpUrlValidator < ActiveModel::EachValidator

  #require 'uri'

  def self.compliant?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && uri.host.present? && uri.host.include?('wikipedia')
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    unless value.present? && self.class.compliant?(value)
      record.errors.add(
        attribute,
        ( options[:message] || "is not a valid HTTP URL" )
      )
    end
  end
end
