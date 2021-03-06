Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection {post :import}
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      # 勤怠変更申請
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month' 
  
   
    end
    collection do
      get 'index_attendance'
    end
    resources :attendances, only: :update do
    member do
        # 残業申請モーダル
        get 'edit_overwork_request'
        patch 'update_overwork_request'
    end
  end
end
  
    resources :bases do
    end
  
  
end