require 'sinatra/base'
require_relative '../data_mapper_setup.rb'

class BookmarkManager < Sinatra::Base
  set :views, proc { File.join(root, 'views') }
  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    'Hello BookmarkManager!'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    # form for submitting new links
    erb :'links/new'
  end

  post '/links' do
    link = Link.new
    link.title = params[:title]
    link.url = params[:url]
    multi_tag = params[:tags].split
    multi_tag_count = multi_tag.count
    multi_tag_count.times do
      tag = Tag.new
      tag.name = multi_tag.shift
      tag.save
      link.tags << tag
    end
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])

    # helper method that looks for the first tag whose name matches the name in the URL

    @links = tag ? tag.links : []

    # if such a tag exists, let @links point to that tag, otherwise return an empty array(otherwise the view will break, since it uses a .each method)

    erb :'links/index'
  end

  get '/users/new' do
    # sign up page for new user
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect to('/links')
  end

  helpers do
    def current_user
      user = User.get(session[:user_id])
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
