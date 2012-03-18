# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title],
                  :rating => movie[:rating],
                  :release_date => movie[:release_date])
  end
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  ratings_field = "ratings_#{field}"
  check(ratings_field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  ratings_field = "ratings_#{field}"
  uncheck(ratings_field)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  ratings_button = "ratings_#{button.downcase}"
  click_button(ratings_button)
end

Then /^(?:|I )should see "([^"]*)" movies$/ do |text|
  path_to_ratings_column = '//table/tbody/tr/td[2]'
  if page.respond_to? :should
    page.should have_xpath(path_to_ratings_column, :text => text)
  else
    assert page.has_xpath?(path_to_ratings_column, :text => text)
  end
end

Then /^(?:|I )should not see "([^"]*)" movies$/ do |text|
  path_to_ratings_column = '//table/tbody/tr/td[2]'
  if page.respond_to? :should
    page.should have_no_xpath(path_to_ratings_column, :text => text)
  else
    assert page.has_no_xpath?(path_to_ratings_column, :text => text)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(%r{,\s*}).each do |rating|
    step %{I check "#{rating}"}
  end
end
