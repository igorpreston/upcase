require "rails_helper"

feature "Accept team invitations" do
  scenario "and signs up" do
    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Name", with: "Team Member"
      fill_in "GitHub username", with: "tmember"
      fill_in "Password", with: "secret"
      click_on "Create an account"

      click_on "Settings"

      expect(page).to have_field("Email", with: "invited-member@example.com")
      expect(page).to have_content("Team: Somedomain")
    end
  end

  scenario "fills in the form incorrectly, then signs up" do
    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Name", with: "Team Member"
      fill_in "GitHub username", with: "tmember"
      click_on "Create an account"

      expect(page).to have_content("can't be blank")

      fill_in "Password", with: "secret"
      click_on "Create an account"

      expect(page).to have_content("Dashboard")
    end
  end

  scenario "user with no github and no subscripion already exists" do
    create(:user, password: "password", email: "invited-member@example.com")

    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "GitHub username", with: "tmember"
      fill_in "Password", with: "password"
      click_on "Join team"

      expect(page).to have_content("You've been added to the team. Enjoy!")

      click_on "Settings"
      expect(page).to have_field("Email", with: "invited-member@example.com")
      expect(page).to have_content("Team: Somedomain")
    end
  end

  scenario "user with github and no subscripion already exists" do
    create(:user, :with_github, email: "invited-member@example.com")

    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Password", with: "password"
      click_on "Join team"

      expect(page).to have_content("You've been added to the team. Enjoy!")

      click_on "Settings"
      expect(page).to have_field("Email", with: "invited-member@example.com")
      expect(page).to have_content("Team: Somedomain")
    end
  end

  scenario "user is authenticated with another email address" do
    user = create(:user, :with_github, email: "member@example.com")

    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      sign_in_as user
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Password", with: "password"
      click_on "Join team"

      expect(page).to have_content("You've been added to the team. Enjoy!")

      click_on "Settings"
      expect(page).to have_field("Email", with: "member@example.com")
      expect(page).to have_content("Team: Somedomain")
    end
  end
end
