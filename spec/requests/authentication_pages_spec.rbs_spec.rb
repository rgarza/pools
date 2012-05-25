require 'spec_helper'

describe "Authentication" do
  subject {page}

  describe "signout page" do

  end
  describe "signin page" do
    before {visit signin_path}

    it { should have_selector('h1', text: 'Sign in')}
    it {should have_selector('title', text: 'Sign in')}

    it {should_not have_link('New Tournament', href: new_tournament_path)}

    describe "invalid login" do
      before { click_button "Sign in"}
      it {should have_selector('div.alert.alert-error')}
      it {should have_selector('title', text: "Sign in")}

      describe "visit other" do
        before {click_link "Home"}
        it {should_not have_selector('.div.alert.alert-error')}
      end
    end

    describe "valid info" do
      let(:user) { FactoryGirl.create(:user)}
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it {should have_selector('title', text: user.name)}
      it {should have_link('Profile', href: user_path(user))}
      it {should have_link('Settings', href: edit_user_path(user))}
      it {should have_link('Sign out', href: signout_path)}
      it {should_not have_link('Sign in', href: signin_path)}
      it {should have_link('New Tournament', href: new_tournament_path)}
      describe "sign out" do
        before do
          click_link "Sign out"
        end
        it {should have_link('Sign in', href: signin_path)}
      end
    end
  end

  describe "Authorization" do 
    
    describe "non signed-in users" do
      let(:user) { FactoryGirl.create(:user)}

      describe "when attempting to access protected page" do 
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after sign in" do
          it "should render desired protected page" do
            page.should have_selector('title', text: "Edit User")
          end
        end
      end

      describe "in users controller" do

        describe "visit edit page" do
          before { visit edit_user_path(user)}
          it { should have_selector('title', text: "Sign in")}
        end

        describe "submit update action" do
          before {put user_path(user)}
          specify { response.should redirect_to(signin_path) }
        end
      end
    
    end
    describe "wrong user" do
      let(:user) { FactoryGirl.create(:user)}
      let(:wrong_user) {FactoryGirl.create(:user, email: "shalala@shalala.com")}
      before { sign_in user}
      describe "visitin user#edit" do
        before { visit edit_user_path(wrong_user)}
        it { should_not have_selector("title", text: "Edit User")}
      end
      describe "submitting wrong user" do
        before { put user_path(wrong_user)}
        specify {response.should redirect_to(root_path) }
      end
    end
  end
end
