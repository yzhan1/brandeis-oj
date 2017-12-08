module UsersHelper
  def gravatar_for user, size
    if !user.profile_pic.nil?
      image_tag(user.profile_pic, alt: user.name, class: "gravatar", size: size)
    else
      image_tag('/aspirinx_logo.png', alt: user.name, class: "gravatar", size: size)
    end
  end
end
