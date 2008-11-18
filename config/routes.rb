ActionController::Routing::Routes.draw do |map|
  
  map.connect '/', :controller => 'questionnaires', :action => 'index'
  # map.home '/', :controller => 'questionnaires'
  
  map.resources :questionnaires, :member => {:duplicate => :post} do |questionnaire|
    questionnaire.resources :contents, :member => { :copy => :get }, :collection => { :sort => :put }
    questionnaire.resources :questions, :member => { :copy => :get }
    questionnaire.resources :display_elements, :member => { :copy => :get }
    # questionnaire.resources :profile_attributes, :member => { :copy => :get }
    # # questionnaire.resources :descriptive_texts, :member => { :copy => :get }
    # questionnaire.resources :answers
    # questionnaire.resources :respondents
    # questionnaire.resources :exports
  end
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
