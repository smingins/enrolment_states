ActionController::Routing::Routes.draw do |map|
  map.root :controller => "students"
  map.resources :students, :member => {:reenrol => :get}
  map.resources :enrolments, :member => {:defer => :get}
end
