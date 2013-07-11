require 'highline/import'

namespace :clear_cms do

  desc 'Add a new admin user.'
  task add_admin: :environment do
    puts "Please complete the following fields for the admin user: "
    name = ask('Display name: ') { |q| q.echo = true }
    email = ask('Email address: ') { |q| q.echo = true }
    base_name = ask('Base name (used in url, letters and _ only): ') {|q| q.echo = true }
    short_name = ask('Short name (used in display instead of full): ') {|q| q.echo = true }
    password = ask('Password: ') { |q| q.echo = '*' }
    password_confirm = ask('Confirm password: ') { |q| q.echo = '*' }

    account = ClearCMS::User.create email: email, password: password, password_confirmation: password_confirm, name: name, base_name: base_name, short_name: short_name, system_permission: 'administrator'
    
    if account.persisted?
      puts "Successfully created admin account."
      puts account.inspect
    else
      
      puts "ERROR creating account:"
      puts "----------------------------------------"
      puts account.errors.full_messages
    end
  end

  desc 'Add a new site.'
  task add_site: :environment do 
    puts "Please complete the following fields for the site: "
    name = ask('Site name for display: ') {|q| q.echo=true}
    domain = ask('Site domain (eg. site.com): ') {|q| q.echo=true}
    slug = ask('Site slug (eg. siteslug, letters and _ only): ') {|q| q.echo=true}

    site = ClearCMS::Site.create name: name, domain: domain, slug: slug 

    if site.persisted?
      puts "Successfully created site."
      puts site.inspect
    else
      puts "ERROR creating account:"
      puts "----------------------------------------"
      puts site.errors.full_messages      
    end
  end

  desc 'Full setup of required environment, with admin user and dummy site.'
  task setup: [:environment, :add_admin]

end