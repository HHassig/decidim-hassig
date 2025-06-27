Rails.application.routes.draw do
  get '/kamal-health', to: proc { [200, {'Content-Type' => 'text/plain'}, ['OK']] }
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  mount Decidim::Core::Engine => "/"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
