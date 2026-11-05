class SessionsController < ApplicationController
  def new
    # Renders the login form view
  end

  def create
    username = params[:username]
    password = params[:password]
    authenticated = false
    user_role = nil

    file_path = Rails.root.join('Password.txt')

    if File.exist?(file_path)
      File.foreach(file_path) do |line|
        # Split line by comma: username, password, role
        user, pass, role = line.chomp.split(',')
        if user == username && pass == password
          authenticated = true
          user_role = role&.strip
          break
        end
      end
    end

    if authenticated
      session[:user_id] = username
      session[:role] = user_role
      flash[:notice] = "Login successful! Welcome, #{username} (#{user_role || 'user'})."
      redirect_to root_path
    else
      flash[:error] = "Invalid username or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    session[:role] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to login_path
  end
end