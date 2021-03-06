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

When /^(?:|I )check "([^"]*)" rating$/ do |field|
  ratings_field = "ratings_#{field}"
  check(ratings_field)
end

When /^(?:|I )uncheck "([^"]*)" rating$/ do |field|
  ratings_field = "ratings_#{field}"
  uncheck(ratings_field)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /^I check the following ratings: (.*)$/ do |rating_list|
  rating_list.split(%r{,\s*}).each do |rating|
    step %{I check "#{rating}" rating}
  end
end

When /^I uncheck the following ratings: (.*)$/ do |rating_list|
  rating_list.split(%r{,\s*}).each do |rating|
    step %{I uncheck "#{rating}" rating}
  end
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  ratings_button = "ratings_#{button.downcase}"
  click_button(ratings_button)
end

When /^(?:|I )click on "Movie Title"$/ do 
  movie_title_link = "title_header"
  click_link(movie_title_link)
end

When /^(?:|I )click on "Release Date"$/ do 
  release_date_link = "release_date_header"
  click_link(release_date_link)
end

Then /^(?:|I )should see "([^"]*)" movies$/ do |text|
  path_to_ratings_column = '//table/tbody/tr/td[2]'
  # Needed in order to avoid false positives like
  # 'G' in 'PG-13' (G is contained in PG-13)
  # 'PG' in 'PG-13' (PG is contained in PG-13)
  regexp = Regexp.new("^#{text}$")

  if page.respond_to? :should
    page.should have_xpath(path_to_ratings_column, :text => regexp)
  else
    assert page.has_xpath?(path_to_ratings_column, :text => regexp)
  end
end

Then /^(?:|I )should not see "([^"]*)" movies$/ do |text|
  path_to_ratings_column = '//table/tbody/tr/td[2]'
  # Needed in order to avoid false positives like
  # 'G' in 'PG-13' (G is contained in PG-13)
  # 'PG' in 'PG-13' (PG is contained in PG-13)
  regexp = Regexp.new("^#{text}$")

  if page.respond_to? :should
    page.should have_no_xpath(path_to_ratings_column, :text => regexp)
  else
    assert page.has_no_xpath?(path_to_ratings_column, :text => regexp)
  end
end

Then /^I should see all of the movies$/ do
  movies_count = Movie.count
  if page.respond_to? :should
    page.should have_css("table#movies tbody tr", :count => movies_count)
  else
    assert page.has_css?("table#movies tbody tr", :count => movies_count)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #e1_appears_before_e2_regexp = Regexp.new(".*#{e1}.*#{e2}.*"/m)
  #puts page.body
  if page.respond_to? :should
    page.body.should =~ /.*#{e1}.*#{e2}.*/m
  else
    assert page.body =~ /.*#{e1}.*#{e2}.*/m
  end
end
