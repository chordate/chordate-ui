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
      Application.where(
        params.slice(:token).merge(:id => params[:application_id])
      ).first
    end
  end
end
