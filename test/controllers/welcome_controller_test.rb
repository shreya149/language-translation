require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all

  setup do
    @user = create(:user, role_id: 1)
    sign_in @user
  end

  def teardown
    User.delete_all
  end

  test "index should render correct template and layout" do
    get :index
    assert_template :index
    assert_template layout: "layouts/application"
  end

end