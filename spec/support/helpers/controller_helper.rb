module ControllerHelper
  def sign_in(user)
    cookies.signed[:token] = user.token
  end

  def sign_out
    cookies.signed[:token] = ""
  end
end
