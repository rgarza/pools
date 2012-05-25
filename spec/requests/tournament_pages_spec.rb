require 'spec_helper'

describe "Tournaments pages" do
 subject { page }
 let(:tournament) { FactoryGirl.create(:tournament)}
  describe "Not logged in" do
    before { visit new_tournament_path }
    it { should have_selector('h1', text: 'Sign in') }
  end

  describe "logged" do
    let(:user) { FactoryGirl.create(:user)}
    before do
     sign_in(user)
     visit new_tournament_path
    end

    it { should have_selector("h1", text: "New Tournament")}

    describe "invalid info" do
      it "should not create" do
        expect{click_button "Create"}.not_to change(Tournament, :count)
      end
    end
    describe "create entry" do      
      before do
        fill_in "Name", with: "name"
        fill_in "Description", with: "description"
      end
      it "should create tournament" do
        expect{ click_button "Create"}.to change(Tournament, :count).by(1)
      end
      
    end
  end
end
