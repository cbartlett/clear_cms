require 'devise/orm/mongoid'

module ClearCMS
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Versioning
    max_versions 10
    
    ROLES=%w(reader alumni contributor intern writer editor managing_editor administrator)
    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable 
    
    #TODO: :registerable
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :encryptable, :lockable, 
            :encryptor=>:sha512, :reset_password_within=>6.hours,
            :stretches=>Rails.env.test? ? 1 : 10,
            :strip_whitespace_keys =>[ :email ], :case_insensitive_keys => [ :email ]

    
    has_many :authored_contents, class_name: 'ClearCMS::Content', :inverse_of=>:author
    has_many :created_contents, class_name: 'ClearCMS::Content', :inverse_of=>:creator
    has_many :assigned_contents, class_name: 'ClearCMS::Content', :inverse_of=>:assignee
    
    belongs_to :default_site, :class_name=>'ClearCMS::Site'
    embeds_many :permissions, class_name: 'ClearCMS::Permission'
    embeds_many :preferences, class_name: 'ClearCMS::Preference'
    
    accepts_nested_attributes_for :permissions, :preferences, :allow_destroy => true
    
    field :full_name
    validates_presence_of :full_name
    
    field :base_name
    validates_presence_of :base_name
    validates_uniqueness_of :base_name
    
    field :short_name
    validates_presence_of :short_name
    validates_uniqueness_of :short_name
    
    field :description
    field :bio
    field :system_permission
    field :active, :type => Boolean
    
    
    field :source_id
    field :source_attributes, type: Hash
    
    #has_many :content_notes, class_name: 'ClearCMS::ContentNote'
    

    ## DEVISE FIELDS
  
    ## Database authenticatable
    field :email,              :type => String #, :null => false
    field :encrypted_password, :type => String #, :null => false
  
    validates_presence_of :email, :encrypted_password
  
    ## Recoverable
    field :reset_password_token,   :type => String
    field :reset_password_sent_at, :type => Time
  
    ## Rememberable
    field :remember_created_at, :type => Time
  
    ## Trackable
    field :sign_in_count,      :type => Integer
    field :current_sign_in_at, :type => Time
    field :last_sign_in_at,    :type => Time
    field :current_sign_in_ip, :type => String
    field :last_sign_in_ip,    :type => String
  
    ## Encryptable
    field :password_salt, :type => String
  
    ## Confirmable
    # field :confirmation_token,   :type => String
    # field :confirmed_at,         :type => Time
    # field :confirmation_sent_at, :type => Time
    # field :unconfirmed_email,    :type => String # Only if using reconfirmable
  
    ## Lockable
    field :failed_attempts, :type => Integer, :default=>0 # Only if lock strategy is :failed_attempts
    field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
    field :locked_at,       :type => Time
  
    mount_uploader :avatar, ClearCMS::Uploaders::ContentAssetUploader 
  
  
    # Token authenticatable
    # field :authentication_token, :type => String
  
    ## Invitable
    # field :invitation_token, :type => String
    
    scope :active, where(active: true)

    def default_site
      ClearCMS::Site.where(:domain=>'coolhunting.com').first
    end
    
    def default_site_id
      ClearCMS::Site.where(:domain=>'coolhunting.com').first.id 
    end
    
    def available_sites
      ClearCMS::Site.all 
    end
    
    def path #for content asset
      "author/#{id}/"
    end

    def friendly_url
      "/author/#{base_name.dasherize}"
    end

    def devise_mailer
        ::Devise::Mailer 
    end
        
  end
end