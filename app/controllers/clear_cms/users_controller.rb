module ClearCMS
  class UsersController < ClearCMS::ApplicationController
    layout 'clear_cms/application'
    before_filter :authenticate_user!
    
    load_and_authorize_resource :class=>'ClearCMS::User'
    
    
    def dashboard
    
    
    end
    
    
    # GET /clear_cms/users
    # GET /clear_cms/users.json
    def index
      #@clear_cms_users = ClearCMS::User.includes(:authored_contents)
      @clear_cms_users = ClearCMS::User #(:updated_at)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @clear_cms_users }
      end
    end

    # GET /clear_cms/users/1
    # GET /clear_cms/users/1.json
    def show
      @clear_cms_user = ClearCMS::User.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @clear_cms_user }
      end
    end

    # GET /clear_cms/users/new
    # GET /clear_cms/users/new.json
    def new
      @clear_cms_user = ClearCMS::User.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @clear_cms_user }
      end
    end

    # GET /clear_cms/users/1/edit
    def edit
      @clear_cms_user = ClearCMS::User.find(params[:id])
    end

    # POST /clear_cms/users
    # POST /clear_cms/users.json
    def create
      
    
      @clear_cms_user = ClearCMS::User.new(params[:user].permit!)
      temporary_password=SecureRandom.base64(13)
      @clear_cms_user.password = temporary_password
      @clear_cms_user.password_confirmation = temporary_password

      respond_to do |format|
        if @clear_cms_user.save
          format.html { redirect_to clear_cms.edit_user_path(@clear_cms_user), notice: 'User was successfully created.' }
          format.json { render json: @clear_cms_user, status: :created, location: @clear_cms_user }
        else
          format.html { render action: "new" }
          format.json { render json: @clear_cms_user.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /clear_cms/users/1
    # PUT /clear_cms/users/1.json
    def update
      @clear_cms_user = ClearCMS::User.find(params[:id])

      respond_to do |format|
        if @clear_cms_user.update_attributes(params[:user].permit!)
          format.html { redirect_to clear_cms.edit_user_path(@clear_cms_user), notice: 'User was successfully updated.' }
          format.json { render json: @clear_cms_user }
        else
          format.html { render action: "edit" }
          format.json { render json: @clear_cms_user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /clear_cms/users/1
    # DELETE /clear_cms/users/1.json
    def destroy
      @clear_cms_user = ClearCMS::User.find(params[:id])
      @clear_cms_user.destroy

      respond_to do |format|
        format.html { redirect_to clear_cms.users_url }
        format.json { head :ok }
      end
    end
    
    def no_permissions
      
    end
  
  end
end
