# Family tree

This is a command-line app to track a family tree. It's an exercise in using Active Record without Rails, and playing around with associations that aren't always straightforward.

So far, the only functionality that's been implemented is tracking which people are married to each other.

Future features:

* Tracking children
* Reporting parents
* Reporting siblings, cousins, uncles/aunts, etc.
* Tracking divorces




  relationships = Relationship.where("parent_one_id = ? or parent_two_id = ?", person_id, person_id)
  # DO NOT EVER EVER EVER EVER DO IT THIS WAY - QUOTES TALK DIRECTLY TO THE DATABASE AND ARE AT RISK FOR SECURITY BREACHES. MUST USE QUESTION MARKS
  # relationships = Relationship.where("parent_one_id = #{person_id} or parent_two_id = #{person_id}")
