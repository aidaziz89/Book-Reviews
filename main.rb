require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'pg'
require 'bcrypt'

enable :sessions

def user_found(users)
  if users.to_a.length > 0
    users[0]
  else
    nil
  end
end


def logged_in?
  !!session[:user_id]
end


def current_user
  if logged_in?
    user_id = session[:user_id]
    users = run_sql("SELECT * FROM users WHERE id=#{user_id}")
    user = user_found(users)
  else
    nil
  end
end

def check_single_quote(movie_string) 
  new_string = ""
  movie_string.each_char do |char|
      new_string += char
      if char=="'"
          new_string += "'"
      end
  end
  return new_string
end

def run_sql(sql)

  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'book_reviews_db'})
  results = db.exec(sql) 
  db.close
  return results
end

get '/' do
  parenting_books = run_sql("SELECT * FROM reviews WHERE genre ILIKE 'parenting%'")
  kids_books = run_sql("SELECT * FROM reviews WHERE genre ILIKE 'kids%'")
  erb :'reviews/index', locals: {
    parenting_books: parenting_books,
    kids_books: kids_books
  }

end

get '/reviews/details/:title' do
  book_title = params["title"]
  books = run_sql("SELECT * FROM reviews WHERE title = '#{book_title}'")
  buku = books.to_a[0]

  comments = run_sql("SELECT * FROM comments WHERE title = '#{book_title}'")

  erb :'reviews/details', locals: {
    buku: buku,
    comments: comments
  }
end

get '/reviews/new' do
  erb :'reviews/new'
end

post '/reviews' do
  book_title = params["title"]
  single_title = check_single_quote(book_title)
  first_name = current_user()["first_name"]
  #book_author = params["author"]
  book_content = params["content"]
  book_genre = params["genre"]
  book_image = params["image_url"]
  single_content = check_single_quote(book_content)

  results = run_sql("INSERT INTO reviews(title, author, content, genre, image_url) VALUES('#{single_title}', '#{first_name}', '#{single_content}', '#{book_genre}', '#{book_image}')")

  redirect '/'
end

get '/signup' do
  erb :'user/signup'
end

post '/users' do
  user_first_name = params["first_name"]
  user_last_name = params["last_name"]
  user_email = params["email"]
  user_password = params["password"]
  password_digest = BCrypt::Password.create(user_password)

  results = run_sql("INSERT INTO users(first_name, last_name, email, password_digest) VALUES('#{user_first_name}', '#{user_last_name}', '#{user_email}', '#{password_digest}')")

  redirect '/'
end

get '/login' do
  erb :'/sessions/login', locals: {
    error_message: ''
  }
end

post '/sessions' do
  user_email = params["email"]
  user_password = params["password"]

  users = run_sql("SELECT * FROM users WHERE email = '#{user_email}'")
  user = user_found(users)

  #Using BCrypt to check that user provided the correct password
  if user && BCrypt::Password.new(user['password_digest']) == params['password']
    #log the user in
    session[:user_id] = user['id']
    redirect '/'

  else 
    erb :'/sessions/login', locals: {
      error_message: 'Sorry, Incorrect Login. Please Try Again.'
    }

  end
end

delete '/sessions' do
  session[:user_id] = nil

  redirect '/'
end

get '/comments/:title/new' do
  book_title = params["title"]
  books = run_sql("SELECT * FROM reviews WHERE title = '#{book_title}'")
  buku = books.to_a[0]
  
  erb :'/comments/new', locals: {
    book_title: book_title,
    buku: buku
  }
end

post '/comments/:title' do
  comments = params["comments"]
  user_id = current_user()["id"]
  user_name = current_user()["first_name"]
  book_title = params["title"]

  run_sql("INSERT INTO comments(comment, title, user_id, user_name) VALUES('#{comments}', '#{book_title}', '#{user_id}', '#{user_name}')")

  redirect '/'
end

get '/comments/:id/edit' do
  comment_id = params["id"]
  comments = run_sql("SELECT * FROM comments WHERE id=#{comment_id}")
  comment = comments[0]

  erb :'/comments/edit', locals: {
    comment: comment
  }
end

patch '/comment/:id' do
  comment_id = params["id"]
  comment = params["comments"]

  run_sql("UPDATE comments SET comment='#{comment}' WHERE id=#{comment_id}")

  redirect '/'
end

delete '/comments/:id' do
  comment_id = params["id"]
  run_sql("DELETE FROM comments WHERE id=#{comment_id};")

  redirect '/'
end











