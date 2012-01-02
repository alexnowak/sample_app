class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    
    puts "params[:session][:email]=#{params[:session][:email]}"
    puts "params[:session][:password]=#{params[:session][:password]}"
    
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])

    puts "user=#{user}"

    if user.nil?
      puts "user not found. Flash an error..."
      flash.now[:error] = "Invalid username/password combination."
      @title = "Sign in"
      render 'new'
    else
      # Sign the user in and redirect to the user's show page.
      puts "User #{user.username} is authenticated successfully!"
      sign_in user
      # TODO: Flash login success ... this does not work yet....
      #flash.now[:success] = "User #{user.username} logged in successfully."
      redirect_to user
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
