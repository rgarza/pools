require 'spec_helper'


describe "User" do
  before { @user =  User.new(name: "rene", email:"rene@hexsoft.pro", password: "password", password_confirmation: "password")}
  subject {@user}

  it { should respond_to(:name)}
  it { should respond_to(:email)}
  it { should respond_to{:password_digest} }
  it { should respond_to{:password_confirmation} }
  it { should respond_to{:password} }
  it { should respond_to {:authenticate} }
  it { should respond_to {:remember_token}}
  it { should be_valid}

  describe "Email not present" do
    before { @user.email = " "}
    it { should_not be_valid}
  end
  describe "Name not present" do
    before {@user.name =" "}
    it { should_not be_valid}
  end

  describe "Name too long" do
    before { @user.name = 'a' * 51}
    it { should_not be_valid }
  end
  describe "incorrect format" do 
    before { @user.email = "renene.com"}
    it { should_not be_valid }
  end

  describe "password not present" do
    before {@user.password = @user.password_confirmation = " "}
    it { should_not be_valid }
  end

  describe "password does not match" do
    before { @user.password_confirmation = "somethingwrong"}
    it { should_not be_valid }
  end
  describe "password conf is null" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "authenticate method" do
    before { @user.save }
    let (:found_user) { User.find_by_email(@user.email)}

    describe "with valid password" do
      it {should == found_user.authenticate(@user.password)}
    end

    describe "invalid pass" do
      let (:user_invalid_password) {found_user.authenticate("invalid")}
      it { should_not == user_invalid_password}
      specify { user_invalid_password.should be_false}
    end
  end
  describe "password short" do
    before {@user.password = @user.password_confirmation = "a" * 5}
    it { should_not be_valid}
  end

  describe "should not allow dups" do 
    before do
      usr_same_email = @user.dup
      usr_same_email.email = @user.email.upcase
      usr_same_email.save
    end
    it {should_not be_valid}
  end

  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end
end
