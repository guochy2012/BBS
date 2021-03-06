require 'spec_helper'

describe User do

  before {@user = User.new(username: "haha",
                           email: "test@test.com",
                           password: "helloworld",
                           password_confirmation: "helloworld")}

  subject {@user}

  #必须存在下列的字段和方法
  it {should respond_to(:username)}
  it {should respond_to(:email)}
  it {should respond_to(:hashed_password)}
  it {should respond_to(:salt)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)}

  it {should be_valid}

  describe "when username is not present" do
    before {@user.username = " "}
    it {should_not be_valid}
  end

  describe "when Email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end

  describe "when name is too long" do
    before {@user.username = "a"*21}
    it {should_not be_valid}
  end


  describe "when Email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when Email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
         @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when username is already exists" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.email = "other@gmail.com"
      user_with_same_username.username = @user.username.upcase
      user_with_same_username.save
    end

    it {should_not be_valid}
  end


  describe "when Email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.username = "hehe"
      user_with_same_email.save
    end

    it {should_not be_valid}
  end

  describe "when password is not present" do
    before do
      @user.password = " "
    end
    it {should_not be_valid}
  end

  describe "when password is too short" do
    before do
      @user.password = "abcdefg"
    end
    it {should_not be_valid}
  end

  describe "when password is too long" do
    before do
      @user.password = "a" * 21
    end
    it {should_not be_valid}
  end

  describe "when password_confirmation is not present" do
    before do
      @user.password_confirmation = " "
    end
    it {should_not be_valid}
  end

  describe "when password doesn't equal password_confirmation" do
    before do
      @user.password = "helloworld"
      @user.password_confirmation = "helloworldOther"
    end
    it {should_not be_valid}
  end


  #密码验证方法
  describe "authenticate authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by(email: @user.email, username: @user.username)}

    describe "with valid password" do
     it {should eq found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      it {should_not eq found_user.authenticate("invalid")}
    end

  end

  #测试token是否为空
  describe "remember token" do
    before { @user.save}
    its(:remember_token) {should_not be_blank}
  end


end
