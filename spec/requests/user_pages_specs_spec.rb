require 'spec_helper'

describe "UserPages" do
  subject {page}
  
  
  describe "signup" do
    before { visit signup_path }
    let (:submit) {"Create my account"}

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: ' | Sign up')}

    describe "with invalid info" do
      it "Should not create" do 
        expect {click_button submit}.not_to change(User, :count)
      end
      describe "error msgs" do
        before {click_button submit}
        it {should have_content('error')}
      end
    end

    describe "With valid info" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "rene@hexsoft.pro"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end
      describe "after saving user" do 
        before {click_button submit}
        let(:user) {User.find_by_email('rene@hexsoft.pro')}
        it {should have_selector('title', text: user.name)}
        it {should have_selector('div.alert.alert-success', text: 'Welcome')}
        it {should have_link('Sign out', href: signout_path)}
      end

    end

  end
  

  describe "profile" do
    let(:user) {FactoryGirl.create(:user)}
    before { visit user_path(user)}
    
    it { should have_selector('h1', text: user.name)}
    it { should have_selector('title', text: " | #{user.name}")}
  end

  describe "edit" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_path(user)       
    end

    describe "page" do 
      it {should have_selector('h1', text: "Update your profile")}
      it { should have_selector('title', text: "Edit User")}
      it { should have_link('change', href: "http://gravatar.com/emails")}
    end
    describe "With invalid info" do
      before { click_button "Save changes" }

      it {should have_content('error')}
    end

    describe "with valid info" do
      let(:new_name) { "Shalala"}
      let(:new_email) { "some@some.com"}
      before do
        fill_in "Email", with: new_email
        fill_in "Name", with: new_name
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      it {should have_selector('title', text: new_name)}
      it {should have_selector('div.alert.alert-success')}
      it {should have_link('Sign out', href: signout_path)}
      specify {user.reload.name.should == new_name}
      specify {user.reload.email.should == new_email}

    end
  end
end

