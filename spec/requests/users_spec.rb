require 'spec_helper'
require 'factory'

describe "Users" do

# An integration test for signing up a new user
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        visit signup_path
        fill_in "Username", :with => ""
        fill_in "Firstname", :with => ""
        fill_in "Lastname", :with => ""
        fill_in "Email", :with => ""
        fill_in "Password", :with => ""
        fill_in "Password Confirmation", :with => ""
        click_button
        response.should render_template('users/new')
        response.should have_selector("div#error_explanation")
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Username", :with => "ExampleUser"
          fill_in "Firstname", :with => "Example"
          fill_in "Lastname", :with => "User"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Password Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

# An integration test for signing in and out
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
end

