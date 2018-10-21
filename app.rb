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
      "content" TEXT,
      "author" TEXT
    )
  )

  @db.execute %(
    CREATE TABLE IF NOT EXISTS
    "comments"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "created_date" DATE,
      "comment" TEXT,
      "post_id" INTEGER
    )
  )
end

get '/' do
  @posts = @db.execute 'select * from posts order by id desc'
  erb :main
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]
  author = params[:author]

  if content.length <= 0
    @error = 'Type text'
    return erb :new
  end

  @db.execute %(
    insert into
    posts (created_date, content, author)
    values (datetime(), ?, ?)
    ), content, author

  redirect to '/'
end

get '/details/:post_id' do
  post_id = params[:post_id]

  results = @db.execute 'select * from posts where id = ?', [post_id]
  @row = results[0]

  @comments = @db.execute 'select * from comments where post_id = ? order by id', [post_id]
  erb :details
end

post '/details/:post_id' do
  post_id = params[:post_id]
  comment = params[:comment]

  @db.execute %(
    insert into
    comments (created_date, comment, post_id)
    values (datetime(), ?, ?)
    ), comment, post_id

  redirect to('/details/' + post_id)
end
