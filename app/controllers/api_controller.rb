class ApiController < ApplicationController

  def authenticate!
    unless application?
      render :json => { :error => {
        :code => 404,
        :messages => ["#<Application id: #{params[:application_id]}, token: #{params[:token]}> not found."] }
      }, :status => :not_found
    end
  end

  def application
    @application ||= begin
      if params[:action] == "create"
        Application.where(
          params.slice(:token).merge(:id => params[:application_id])
        ).first
      elsif params[:action] == "update"
        @user = User.where(params.slice(:token)).first

        @user && @user.applications.where(:id => params[:application_id]).first
      end
    end
  end
end
