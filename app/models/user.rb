require 'digest/sha1'
require 'net/pop'
require 'net/https'
require 'net/http'
require 'json'

class User < ActiveRecord::Base
  has_many :submissions
  has_many :matches, through: :submissions



  scope :activated_users, :conditions => {:activated => true}

  validates_presence_of :login
  validates_uniqueness_of :login
  validates_format_of :login, :with => /^[\_A-Za-z0-9]+$/
  validates_length_of :login, :within => 3..30

  validates_presence_of :full_name
  validates_length_of :full_name, :minimum => 1
  
  validates_presence_of :password, :if => :password_required?
  validates_length_of :password, :within => 4..20, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?

  validates_format_of :email, 
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
                      :if => :email_validation?
  validate :uniqueness_of_email_from_activated_users, 
           :if => :email_validation?
  validate :enough_time_interval_between_same_email_registrations, 
           :if => :email_validation?

  # these are for ytopc
  # disable for now
  #validates_presence_of :province

  attr_accessor :password

  before_save :encrypt_new_password
  before_save :assign_default_site
  before_save :assign_default_contest

  # this is for will_paginate
  cattr_reader :per_page
  @@per_page = 50

  def self.authenticate(login, password)
    user = find_by_login(login)
    if user
      return user if user.authenticated?(password)
      if user.authenticated_by_cucas?(password) or user.authenticated_by_pop3?(password)
        user.password = password
        user.save
        return user
      end
    end
  end

  def authenticated?(password)
    if self.activated
      hashed_password == User.encrypt(password,self.salt)
    else
      false
    end
  end

  def authenticated_by_pop3?(password)
    Net::POP3.enable_ssl
    pop = Net::POP3.new('pops.it.chula.ac.th')
    authen = true
    begin
      pop.start(login, password)
      pop.finish
      return true
    rescue 
      return false
    end
  end

  def authenticated_by_cucas?(password)
    url = URI.parse('https://www.cas.chula.ac.th/cas/api/?q=studentAuthenticate')
    appid = '41508763e340d5858c00f8c1a0f5a2bb'
    appsecret ='d9cbb5863091dbe186fded85722a1e31'
    post_args = {
      'appid' => appid,
      'appsecret' => appsecret,
      'username' => login,
      'password' => password
    }

    #simple call
    begin
      http = Net::HTTP.new('www.cas.chula.ac.th', 443)
      http.use_ssl = true
      result = [ ]
      http.start do |http|
        req = Net::HTTP::Post.new('/cas/api/?q=studentAuthenticate')
        param = "appid=#{appid}&appsecret=#{appsecret}&username=#{login}&password=#{password}"
        resp = http.request(req,param)
        result = JSON.parse resp.body
      end
      return true if result["type"] == "beanStudent"
    rescue
      return false
    end
    return false
  end

  def admin?
    self.roles.detect {|r| r.name == 'admin' }
  end

  def email_for_editing
    if self.email==nil
      "(unknown)"
    elsif self.email==''
      "(blank)"
    else
      self.email
    end
  end

  def email_for_editing=(e)
    self.email=e
  end

  def alias_for_editing
    if self.alias==nil
      "(unknown)"
    elsif self.alias==''
      "(blank)"
    else
      self.alias
    end
  end

  def alias_for_editing=(e)
    self.alias=e
  end

  def activation_key
    if self.hashed_password==nil
      encrypt_new_password
    end
    Digest::SHA1.hexdigest(self.hashed_password)[0..7]
  end

  def verify_activation_key(key)
    key == activation_key
  end

  def self.random_password(length=5)
    chars = 'abcdefghjkmnopqrstuvwxyz'
    password = ''
    length.times { password << chars[rand(chars.length - 1)] }
    password
  end

  def self.find_non_admin_with_prefix(prefix='')
    users = User.find(:all)
    return users.find_all { |u| !(u.admin?) and u.login.index(prefix)==0 }
  end

  protected
    def encrypt_new_password
      return if password.blank?
      self.salt = (10+rand(90)).to_s
      self.hashed_password = User.encrypt(self.password,self.salt)
    end

    def password_required?
      self.hashed_password.blank? || !self.password.blank?
    end
 
    def self.encrypt(string,salt)
      Digest::SHA1.hexdigest(salt + string)
    end

    def uniqueness_of_email_from_activated_users
      user = User.activated_users.find_by_email(self.email)
      if user and (user.login != self.login)
        self.errors.add_to_base("Email has already been taken")
      end
    end

    def enough_time_interval_between_same_email_registrations
      return if !self.new_record?
      return if self.activated
      open_user = User.find_by_email(self.email,
                                     :order => 'created_at DESC')
      if open_user and open_user.created_at and 
          (open_user.created_at > Time.now.gmtime - 5.minutes)
        self.errors.add_to_base("There are already unactivated registrations with this e-mail address (please wait for 5 minutes)")
      end
    end

    def email_validation?
      begin
        return VALIDATE_USER_EMAILS
      rescue
        return false
      end
    end
end
