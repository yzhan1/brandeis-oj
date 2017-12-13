module UsersHelper
  def gravatar_for user, size
    picture = user.profile_pic.nil? ? '/aspirinx_logo.png' : user.profile_pic
    image_tag(picture, alt: user.name, class: "gravatar", size: size)
  end
end
