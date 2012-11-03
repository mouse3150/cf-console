load 'zip_util.rb'
require 'cloudfoundry'

#require 'zip/zipfilesystem'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :require_login
  include CFCZIP

  private
  def require_login
    begin
      @cf_client = cloudfoundry_client(cookies[:cf_target_url], cookies.signed[:cf_auth_token])
      @cf_logged_in = @cf_client.logged_in?
    rescue Exception
      @cf_logged_in = false
    end
    if @cf_logged_in
      @cf_user = @cf_client.user
      @cf_target_url = @cf_client.target_url
      begin
        user = User.new(@cf_client)
        @cf_admin_user = user.is_admin?(@cf_user)
      rescue CloudFoundry::Client::Exception::Forbidden
        @cf_admin_user = false
      end
    else
      redirect_to login_url
    end
  end

  def require_admin
    unless @cf_admin_user
      flash[:alert] = I18n.t('meta.operation_not_permitted')
      redirect_to root_url
    end
  end

  def cloudfoundry_client(cf_target_url, cf_auth_token = nil)
    cf_target_url ||= CloudFoundry::Client::DEFAULT_TARGET
    @client = CloudFoundry::Client.new({:adapter => which_faraday_adapter?, :target_url => cf_target_url, :auth_token => cf_auth_token})
  end

  def which_faraday_adapter?
    if defined?(EM::Synchrony) && EM.reactor_running?
      :em_synchrony
    else
      :net_http
    end
  end

  def set_locale
    available_locales = (I18n.available_locales.collect { |lang| lang.to_s } & configatron.languages.available)
    params_locale = ([params[:locale]] & available_locales).first
    cookies_locale = ([cookies[:cf_locale]] & available_locales).first
    browser_locale = (user_agent_locale & available_locales).first
    I18n.locale = params_locale || cookies_locale || browser_locale || I18n.default_locale
    cookies.permanent[:cf_locale] = I18n.locale
  end

  def user_agent_locale
    user_agent_languages ||= request.env['HTTP_ACCEPT_LANGUAGE'].split(/\s*,\s*/).collect do |lang|
      lang += ";q=1.0" unless lang =~ /;q=\d+\.\d+$/
      lang.split(";q=")
    end.sort do |x, y|
      y.last.to_f <=> x.last.to_f
    end.collect do |lang|
      lang.first.downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
    end
  rescue
    []
    end

  def generate_random(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    random_chars = ""
    1.upto(len) { |i| random_chars << chars[rand(chars.size-1)] }
    return random_chars
  end

  def  uploadfile(file)
    if !file.original_filename.empty?
      filename = getfilename(file.original_filename)
      file_path = Rails.root + "public/files/#{filename}"
      File.open(file_path, "wb") do |f|
        f.write(file.read)
      end
    return file_path
    end
  end

  def getfilename(filename)
    if !filename.nil?
      return filename = generate_random(10) + "_" + filename
    end
  end

end
