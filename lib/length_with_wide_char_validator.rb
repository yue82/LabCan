class LengthWithWideCharValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    count = 0
    value.split(//).each do |v|
      v.bytesize > 1 ? count += 2 : count += 1
    end
    object.errors[attribute] << (options[:message] || "is too long (maximum is %d characters)" % options[:maximum]) if count > options[:maximum]
  end
end
