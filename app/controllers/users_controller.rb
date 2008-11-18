class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:new, :create]
  before_filter :find_user, :only => [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def edit
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your account has been updated."
      respond_to do |wants|
        wants.html  { redirect_to @user }
        wants.js    { render :nothing => true }
      end
    else
      flash[:error]  = "We couldn't update your account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'edit'
    end
  end
  
private
  
  def find_user
    @user = User.find(params[:id])
  end
  
end
