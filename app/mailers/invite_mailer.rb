class InviteMailer < ActionMailer::Base
  def invited(invite_id)
    @invite = Invite.find(invite_id)

    mail(:to => @invite.email, :subject => I18n.t("invite.mailer.invited.subject"))
  end
end
