# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert page.body =~ /#{e1}.*#{e2}/m, %Q{"#{e1}" should be before "#{e2}"}
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/,\s*/).each do |rating|
    step %Q{I #{$1}check "ratings_#{rating}"}
  end
  step %Q{I press "ratings_submit"}
end

Then /I should see all of the movies/ do
  # Could have used either of the following as well
  #page.has_css?("table#movies tbody tr")#, :count => Movie.count)
  #page.has_xpath?('.//table[@id="movies"]/tbody/tr', :count => Movie.count),

  # Compute the number of rows in the table
  rows = page.all("table#movies tbody tr").count
  assert_equal Movie.count, rows
end

# Unused: The assignment didn't describe this and the autograder doesn't check
Then /I should see none of the movies/ do
  rows = page.all("table#movies tbody tr").count
  assert_equal 0, rows
end
