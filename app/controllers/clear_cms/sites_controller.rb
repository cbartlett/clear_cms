module ClearCMS
  class SitesController < ApplicationController
    before_filter :authenticate_user!
    load_and_authorize_resource :class=>'ClearCMS::Site'

    # GET /clear_cms/sites
    # GET /clear_cms/sites.json
    def index
      @clear_cms_sites = ClearCMS::Site.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @clear_cms_sites }
      end
    end

    # GET /clear_cms/sites/1
    # GET /clear_cms/sites/1.json
    def show
      @clear_cms_site = ClearCMS::Site.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @clear_cms_site }
      end
    end

    # GET /clear_cms/sites/new
    # GET /clear_cms/sites/new.json
    def new
      @clear_cms_site = ClearCMS::Site.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @clear_cms_site }
      end
    end

    # GET /clear_cms/sites/1/edit
    def edit
      @clear_cms_site = ClearCMS::Site.find(params[:id])
    end

    # POST /clear_cms/sites
    # POST /clear_cms/sites.json
    def create
      @clear_cms_site = ClearCMS::Site.new(params[:site])

      respond_to do |format|
        if @clear_cms_site.save
          format.html { redirect_to({ :action => :index }, notice: 'Site was successfully created.')}
          format.json { render json: @clear_cms_site, status: :created, location: @clear_cms_site }
        else
          format.html { render action: "new" }
          format.json { render json: @clear_cms_site.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /clear_cms/sites/1
    # PUT /clear_cms/sites/1.json
    def update
      @clear_cms_site = ClearCMS::Site.find(params[:id])

      respond_to do |format|
        if @clear_cms_site.update_attributes(params[:site])
          format.html { redirect_to({ :action => :index }, notice: 'Site was successfully updated.')}
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @clear_cms_site.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /clear_cms/sites/1
    # DELETE /clear_cms/sites/1.json
    def destroy
      @clear_cms_site = ClearCMS::Site.find(params[:id])
      @clear_cms_site.destroy

      respond_to do |format|
        format.html { redirect_to clear_cms_sites_url }
        format.json { head :ok }
      end
    end
  end
end
