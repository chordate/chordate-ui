class InvitesController < ApplicationController
  before_filter :application, :only => [:create]
  skip_before_filter :authenticate!, :only => [:show, :update]

  def show
    redirect_to(new_session_path) unless invite.redeem

    if invite.user?
      (@item = invite.user) && set_cookie

      redirect_to(application_path(invite.application))
    end
  end

  def create
    invite = Invite.new(params.slice(:email, :user, :application))

    render :json => InviteDecorator.new(invite).tap(&:save), :status => :created
  end

  def update
    @item = invite.create(params.slice(:name, :password))

    if invite.created?
      set_cookie && (render :json => invite)
    else
      head 422
    end
  end

  private

  def invite
    @invite ||= begin
      InviteDecorator.new(
        Invite.where(params.slice(:id, :application_id, :token)).first
      )
    end
  end
end
