Given /^I am logged in as "([^"]*)"$/ do |name|
  user = User.find_by_name(name) || Factory(:user, :name => name)

  Given %Q{I am on the homepage}
   When %Q{I follow "Sign in"}
   Then %Q{I should be on the signin page}
   When %Q{I fill in "Email" with "#{user.email}"}
    And %Q{I fill in "Password" with "foobar"}
    And %Q{I press "Sign in"}
   Then %Q{I should see "Welcome #{user.name}"}
end
