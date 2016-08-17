require 'models/task_manager'

class TaskManagerApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)
  set :method_override, true # <= overrides the silly web browser for PUT or DELETE methods

  get '/' do
    erb :dashboard
  end

  get '/tasks' do
    @tasks = task_manager.all
    erb :index
  end

  get '/tasks/new' do
    erb :new
  end

  post '/tasks' do
    task_manager.create(params[:task])
    redirect '/tasks'
  end

  get '/tasks/:id' do
    @task = task_manager.find(params[:id].to_i)
    erb :show
  end

  get '/tasks/:id/edit' do
    @task = task_manager.find(params[:id].to_i)
    erb :edit
  end

  put '/tasks/:id' do
    task_manager.update(params[:id].to_i, params[:task])
    redirect "/tasks/#{params[:id]}"
  end

  delete '/tasks/:id' do
    task_manager.destroy(params[:id].to_i)
    redirect '/tasks'
  end

  def task_manager
    database = YAML::Store.new('db/task_manager')
    @task_manager ||= TaskManager.new(database)
  end

end
