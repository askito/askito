# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4764c294fd626b8c4131f90b48540259'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  include AuthenticatedSystem
  before_filter :login_required
  
  class AccessDenied < StandardError; end
  
  
protected
  
  def render_invalid_record(record)
    flash[:error] = record.errors.full_messages.to_sentence
    respond_to do |format|
      format.html { render :action => (record.new_record? ? 'new' : 'edit') }
      format.xml  { render :xml => record.errors, :status => :unprocessable_entity }
      format.js do
        render :update do |page|
          page.replace_html "flashes", :partial => "shared/flash"
          page.delay(15) do
            page.replace_html "flashes", ""
          end
        end
      end
    end
  end
  
  def default_flash_message(object)
    case params[:action]
    when 'create'
      flash[:notice] = "The #{object.class.name.titleize.downcase} was successfully created."
    when 'update'
      flash[:notice] = "The #{object.class.name.titleize.downcase} was updated."
    when 'destroy'
      flash[:notice] = "The #{object.class.name.titleize.downcase} was deleted."
    end
  end
  
  def reset_flash
    flash[:notice] = nil
    flash[:error] = nil
  end
  
  
end
