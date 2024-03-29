# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT movies.title 
  FROM movies 
  JOIN castings ON castings.movie_id = movies.id
  JOIN actors ON actors.id = castings.actor_id
  where actors.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT movies.title 
  from movies 
  JOIN castings ON castings.movie_id = movies.id
  JOIN actors ON actors.id = castings.actor_id
  where actors.name = 'Harrison Ford' and castings.ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT movies.title, actors.name
  from movies 
  JOIN castings ON castings.movie_id = movies.id
  JOIN actors ON actors.id = castings.actor_id
  where castings.ord = 1 and movies.yr = 1962  
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT movies.yr, count(*) as movies_number
  FROM movies
  JOIN castings ON castings.movie_id = movies.id
  JOIN actors ON actors.id = castings.actor_id
  where actors.name = 'John Travolta'
  group by movies.yr
  Having count(*) >= 2
  # SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  Select movies.title, actors.name
  JOIN castings ON castings.movie_id = movies.id
  JOIN actors ON actors.id = castings.actor_id
  where movies.id in (SELECT movies.id
  FROM movies
  JOIN castings ON castings.movie_id = movies.id
  JOIN actors ON actors.id = castings.actor_id
  where actors.name =  'Julie Andrews' )
  and castings.ord = 1


  
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  ##### Not tested
    SELECT actors.name 
    FROM actors 
    Join castings on castings.actor_id = actors.id
    group by actors.name
    HAVING COUNT(castings.ord) > 15
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    SELECT movies.title 
    FROM movies
    join on castings.movie_id = movies.id
    where movies.yr = 1978
    group movies.title
    order by sum(castings.actor_id) DESC,
    title 
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
    SELECT actors.name 
    FROM actors
    join on castings.actor_id = actors.id
    group by actors.name
    where movies.id in ( 
    SELECT movies.id 
    from movies
    join castings on castings.movie_id = movies.id
    join actors on castings.actor_id = actors.id
    where 
    actor = 'Art Garfunkel'
    )
  SQL
end
