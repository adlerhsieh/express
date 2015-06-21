class SettingsController < ApplicationController
  before_action :require_admin

  def edit_all
    @title = Setting.create_with(:tag => "網站標題").find_or_create_by(key: "site_title")
    @meta_title = Setting.create_with(:tag => "META：標題").find_or_create_by(key: "meta_title")
    @meta_keywords = Setting.create_with(:tag => "META：關鍵字").find_or_create_by(key: "meta_keywords")
    @meta_description = Setting.create_with(:tag => "META：說明").find_or_create_by(key: "meta_description")
    @og_type = Setting.create_with(:tag => "社群分享：類別", :value => "website").find_or_create_by(key: "meta_description")
    @og_title = Setting.create_with(:tag => "社群分享：標題").find_or_create_by(key: "og_title")
    @og_url = Setting.create_with(:tag => "社群分享：連結網址").find_or_create_by(key: "og_url")
    @og_site_name = Setting.create_with(:tag => "社群分享：網站名稱").find_or_create_by(key: "og_site_name")
    @og_description = Setting.create_with(:tag => "社群分享：說明").find_or_create_by(key: "og_description")
    @favicon = Setting.create_with(:tag => "網站Favicon位置").find_or_create_by(key: "favicon_location")
    @ga = Setting.create_with(:tag => "GA程式碼").find_or_create_by(key: "ga")
    @settings = Setting.all
  end

  def update_all
    settings = params
    settings.delete(:utf8)
    settings.delete(:authenticity_token)
    settings.delete(:controller)
    settings.delete(:action)
    settings.delete(:commit)
    settings.each do |key, value|
      if setting = Setting.find_by_key(key)
        setting.update_attribute(:value, value)
      end
    end
    flash[:notice] = "設定更新完成"
    redirect_to edit_all_settings_path
  end
end
