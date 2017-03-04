require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "John Doe", email: "johndoe@example.com", password:"foobar",password_confirmation:"foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name length should not be too long" do
    @user.name = "A"*51
    assert_not @user.valid?
  end

  test "email length should not be too long" do
    @user.name = "A"*244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = ["user@example.com", "USER@foo.COM", "JohnDoe@ge.inbox.com", "A_US-ER@foo.bar.org",
                       "first.last@foo.jp", "alice+bob@baz.cn"]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end


  test "email should be unique" do
    user2 = @user.dup
    user2.email = @user.email.upcase
    @user.save
    assert_not user2.valid?
  end

  test "email should be lowercased" do
    @user.email = "JOHNDOE@example.com"
    @user.save
    assert_equal @user.reload.email, "johndoe@example.com"
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end
