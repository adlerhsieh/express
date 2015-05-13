class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  require 'bing_translator'

  def is_admin?
    is_admin
  end

  def translator_balance
    t = BingTranslator.new("motionexpress","XElPnc0gckRHGyAgi7Y6wV8nxiLU4GDPDUivxrfRoYo=", false, 'FPiShpptVGkvVNAIGXoV//zHZMtvIAgsG/PiVSztHb8')
    t.balance
  end

  def translator_usage
    days = Time.days_in_month(Time.now.month, Time.now.year)
    max = (2000000 - translator_balance).to_f
    (max / days).round(2)
  end
end
