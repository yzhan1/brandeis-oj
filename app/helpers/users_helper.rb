module UsersHelper
  def gravatar_for user
    image_tag(user.profile_pic, alt: user.name, class: "gravatar", size: 200) if !user.profile_pic.nil?
  end
end
