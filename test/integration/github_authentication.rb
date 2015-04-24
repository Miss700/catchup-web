require "test_helper"

class GitHubAuthenticationTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.add_mock(
      :github,
      info: { nickname: "as-cii", image: "as-cii.jpg", email: "me@as-cii.com" }
    )
  end

  test "Anonymous signs up" do
    # Given I haven't signed in yet
    # And I am on the landing page
    visit root_path

    # When I start the sign in process
    click_on t("anonymous.index.signup")

    # Then I get signed in with my account information
    assert has_text?("as-cii")
    assert has_text?("me@as-cii.com")
    assert has_css?("img[src*='as-cii.jpg']")
  end

  test "Anonymous signs in" do
    # Given I have previously signed in
    User.create!(
      avatar_url: "as-cii.jpg",
      nickname: "as-cii",
      email: "me@as-cii.com"
    )

    # And I am on the landing page
    visit root_path

    # When I start the sign in process
    click_on t("anonymous.index.signup")

    # Then I get signed in with my previous account information
    assert has_text?("as-cii")
    assert has_text?("me@as-cii.com")
    assert has_css?("img[src*='as-cii.jpg']")
  end

  test "Anonymous fails to authenticate" do
    # Given I don't remember my OAuth credentials
    OmniAuth.config.mock_auth[:github] = :invalid_credentials

    # And I am on the landing page
    visit root_path

    # When I start the sign in process
    click_on t("anonymous.index.signup")

    # Then I won't be able to sign in
    assert has_text?(t("anonymous.index.auth_failure"))
  end

  test "Anonymous visits a 'signed in users' page"

  test "Signed in user logs out"
end
