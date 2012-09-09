# -*- encoding: utf-8 -*-
class SessionsController < ApplicationController
  def callback
    #omniauth.auth環境変数を取得
    auth = request.env["omniauth.auth"]
    #Omniuserモデルを検索。:providerと:uidが存在しているか調べるため。
    omniuser = Omniuser.find_by_provider_and_uid(auth["provider"], auth["uid"])
    #①Omniuserモデルに:providerと:uidが存在してる？
    logger.debug "auth -> #{auth}"
    logger.debug "omniuser -> #{omniuser}"
    unless omniuser
      omniuser = Omniuser.create_with_omniauth(auth)
      logger.debug "omniuser -> #{omniuser}"
      
      password  = User.randam_string
      user      = User.create :email => (auth["info"] && auth["info"]["email"]) ? auth["info"]["email"] : "#{omniuser.id}@#{auth["provider"]}.jp", :password => password, :password_confirmation => password
      omniuser.update_attribute :user_id, user.id
      logger.debug "user.errors.full_messages.join -> #{user.errors.full_messages.join}"
    else
      user = User.find_by_id(omniuser.user_id)
    end
    logger.debug "user -> #{user}"
    sign_in :user, user
    return redirect_to root_url
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "ログアウトしました。"
  end
end
