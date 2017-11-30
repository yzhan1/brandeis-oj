module UsersHelper
  def gravatar_for user
    image_tag(user.profile_pic, alt: user.name, class: "gravatar", size: 200)
  end
end
