We set our topic being about Starbucks because we are in Seattle, the founding city of Starbucks. 
At the beginning, our vision was that we were going to make a sophisticated system that serves both the stores and the customers, all in depth.
While we were designing our ERD diagram, we realized the relationships between stores and customers were just too complicated as it is,
and would pose unnecessary and probably unsolvable setbacks later on in the coding and dataset implementation process. So we narrowed it down to a more “store side focused” system,
while including the role of customers in the relationship chain. Moving on to the database implementation phase, we learned about the intricacies of managing foreign keys in ternary relationships,
which are very prone to errors if everything is not lined up perfectly. We encountered difficulties when inserting columns from temporary tables into real tables, often mixing up the table hierarchy and violating NULL value constraints.
Additionally, inconsistencies in data types led to challenges during the insertion process, and formatting issues in PostgreSQL occasionally resulted in errors as well. 

To address these challenges, we started by clarifying the dependencies between different elements of our database, this way we vget to insert data accurately according to class hierarchies.
By reviewing all keys and recreating tables for all many to many relationships, we ensured correct relational structure within our database. I’ll say that one of the most significant lessons
learned was the importance of accurately understanding and implementing parent child relationships in our database schema.
That and not getting over yourself earlier on in the process, if we had gone with what we envisioned during the ERD diagram phase, we’d be in bigger trouble.
Overall I’d say this project had been very useful in connecting all the skills we had learned over this quarter.
