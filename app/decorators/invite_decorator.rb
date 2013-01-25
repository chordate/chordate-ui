class InviteDecorator
  include Decorator

  allow :email, :token, :shown

  attr_reader :user

  def application
    invite.application
  end

  def save
    invite.save.tap do
      invite.tap_if(:persisted?) do
        InviteMailer.invited(invite.id).deliver
      end
    end
  end

  def created?
    !!@created
  end

  def create(options)
    @create ||= begin
      options[:account] = application.account

      User.where(:email => invite.email).
        first_or_create(options.slice(:name, :password, :account)) do |user|
          @created = true

          application.users << user
      end
    end
  end

  def redeem
    can_redeem?.tap_if do
      User.where(:email => invite.email).first.tap_if do |user|
        @user = user

        ApplicationUser.where(:application_id => application.id, :user_id => user.id).tap_if(:empty?) do
          application.users << @user
        end
      end
    end
  end

  def user?
    !!@user
  end

  private

  def can_redeem?
    @any ||= invite.present? &&
      application.users.where(:id => invite.user.id).any?

    (@any && invite.update_attributes(:shown => Time.now))
  end
end
