require 'rubygems'
require 'sinatra'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash = true
end

before do
  init_db
  # @db.results_as_hash = true
  # @posts = @db.execute 'select * from posts order by id desc'
end

configure do
  init_db

  @db.execute %(
    CREATE TABLE IF NOT EXISTS
    "posts"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "created_date" DATE,
      "content" TEXT
    )
  )
end

get '/' do
  erb :main
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  if content.length <= 0
    @error = 'Type text'
    return erb :new
  end

  erb "You typed #{content}"
end
