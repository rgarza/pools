require 'spec_helper'

describe Tournament do
  let(:user) { FactoryGirl.create(:user)}
  before { @tournament = user.tournaments.build(name: "clausura 2012", description: "Torneo de clausura 2012") }
  subject { @tournament }

  it { should respond_to(:name) }
  it { should respond_to(:description)}

  it { should be_valid}
  describe "name too long" do
    before { @tournament.name = 'a' * 200 } 
    it { should_not be_valid }
  end

  describe "name empty" do
    before { @tournament.name = ""}
    it { should_not be_valid}
  end

  describe "description empty" do
    before { @tournament.description = ""}
    it { should_not be_valid}
  end
end
