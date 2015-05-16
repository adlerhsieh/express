class UsersController < ApplicationController
  layout "backend"
  before_action :require_login

  def show
    @user = User.find_by_name(params[:name])
  end

  def balance
    render :json => {
      :balance => translator_balance,
      :usage => translator_usage
    }
  end

  private

  def translator_balance
    t = BingTranslator.new("motionexpress","XElPnc0gckRHGyAgi7Y6wV8nxiLU4GDPDUivxrfRoYo=", false, 'FPiShpptVGkvVNAIGXoV//zHZMtvIAgsG/PiVSztHb8')
    t.balance
    # "暫不顯示"
  end

  def translator_usage
    days = Time.days_in_month(Time.now.month, Time.now.year)
    max = (2000000 - translator_balance).to_f
    (max / days).round(2)
  end

end
