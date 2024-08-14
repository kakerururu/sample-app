require "test_helper"

class UserTest < ActiveSupport::TestCase

  # setupは特殊で、各テストメソッドが実行される直前に実行される
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  test "should be valid" do
    assert @user.valid?
    # モデルのルールに従っているかどうかを確認する。
    # この場合はUserモデルのバリデーションに従っているかどうかを確認している。
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
    # ユーザー名が空白でないかどうかを確認する。
    # この場合はFalseであれば正しい。
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
    # メールアドレスが空白でないかどうかを確認する。
    # この場合はFalseであれば正しい。
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
    # ユーザー名が50文字以下であるかどうかを確認する。
    # この場合はFalseであれば正しい。
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
    # メールアドレスが255文字以下であるかどうかを確認する。
    # この場合はFalseであれば正しい。
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    # この時、失敗したときのメッセージを表示する。
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    # この時、失敗したときのメッセージを表示する。
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup

    @user.save
    assert_not duplicate_user.valid?
    # 重複したメールアドレスが保存されないかどうかを確認する。
    # この場合はFalseであれば正しい。
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
    # パスワードが空白でないかどうかを確認する。
    # この場合はFalseであれば正しい。
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
    # パスワードが6文字以上であるかどうかを確認する。
    # この場合はFalseであれば正しい。
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end