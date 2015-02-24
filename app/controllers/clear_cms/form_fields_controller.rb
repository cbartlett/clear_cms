module ClearCMS
  class FormFieldsController < ClearCMS::ApplicationController


    def index
      @form_fields = ClearCMS::Content.form_fields

      respond_to do |format|
        format.json { render json: @form_fields }
      end

    end
  end
end
