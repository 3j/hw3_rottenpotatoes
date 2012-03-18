Feature: (COMPLEMENT TO) display list of movies filtered by MPAA rating
 
  As a concerned parent
  So that I can quickly browse movies appropriate for my family
  I want to see movies matching only certain MPAA ratings

Background: movies have been added to database

  Given the following movies exist:
  | title                   | rating | release_date |
  | Aladdin                 | G      | 25-Nov-1992  |
  | The Terminator          | R      | 26-Oct-1984  |
  | When Harry Met Sally    | R      | 21-Jul-1989  |
  | The Help                | PG-13  | 10-Aug-2011  |
  | Chocolat                | PG-13  | 5-Jan-2001   |
  | Amelie                  | R      | 25-Apr-2001  |
  | 2001: A Space Odyssey   | G      | 6-Apr-1968   |
  | The Incredibles         | PG     | 5-Nov-2004   |
  | Raiders of the Lost Ark | PG     | 12-Jun-1981  |
  | Chicken Run             | G      | 21-Jun-2000  |

  And  I am on the RottenPotatoes home page
  
Scenario: restrict to movies with 'R' ratings (NO PROBLEM)
  When I check the following ratings: R 
  And I uncheck the following ratings: PG, PG-13, NC-17, G
  When I press "Submit"
  Then I should see "R" movies
  And I should not see "PG" movies
  And I should not see "PG-13" movies
  And I should not see "NC-17" movies
  And I should not see "G" movies

Scenario: restrict to movies with 'G' ratings (NO PROBLEM)
  When I check the following ratings: G 
  And I uncheck the following ratings: PG, PG-13, NC-17, R
  When I press "Submit"
  Then I should see "G" movies
  And I should not see "PG" movies
  And I should not see "PG-13" movies
  And I should not see "NC-17" movies
  And I should not see "R" movies

Scenario: restrict to movies with 'PG-13' ratings (PROBLEMATIC)
  When I check the following ratings: PG-13 
  And I uncheck the following ratings: G, PG, NC-17, R
  When I press "Submit"
  Then I should see "PG-13" movies
  And I should not see "NC-17" movies
  And I should not see "R" movies
  And I should not see "PG" movies 
  And I should not see "G" movies

Scenario: restrict to movies with 'PG-13' ratings (Should Fail 'G')
  When I check the following ratings: PG-13 
  And I uncheck the following ratings: G, PG, NC-17, R
  When I press "Submit"
  Then I should see "PG-13" movies
  And I should not see "NC-17" movies
  And I should not see "R" movies
  And I should not see "PG" movies 
  # This step should fail.
  #And I should see "G" movies
