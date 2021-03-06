module UsersHelper

  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def icon_for(user)
    user.user_icon.url || '/default/user_icon.jpg'
  end

  def gray_icon_for(user)
    user.user_icon.gray.url || '/default/gray_icon.jpg'
  end

  def temp_icon_for(user)
    user.temp_icon.url || '/default/user_icon.jpg'
  end

  def name_for(user)
    logged_in? ? user.name : 'Guest'
  end

end
