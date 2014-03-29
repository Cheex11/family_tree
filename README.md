# Family tree

This is a command-line app to track a family tree. It's an exercise in using Active Record without Rails, and playing around with associations that aren't always straightforward.

Has the ability to view a person's

So far, the only functionality that's been implemented is tracking which people are married to each other.

Features:

* Tracking children
* Reporting parents
* Reporting siblings, cousins, uncles/aunts, grandparents, grandchildren, and inlaws

Future feature:
* Tracking divorces



*Always use question marks when talking directly to the database in the parameter to keep database info safe. Using string interpolation gives user the ability to call things from the database.

relationships = Relationship.where("parent_one_id = ? or parent_two_id = ?", person_id, person_id)
VS
* relationships = Relationship.where("parent_one_id = #{person_id} or parent_two_id = #{person_id}")


