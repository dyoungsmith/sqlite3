-- Fame Name Game
-- Returns 2 column table with names listed by reverse popularity
SELECT first_name, COUNT(first_name) 
	FROM actors 
	GROUP BY first_name 
	ORDER BY COUNT(first_name) 
	DESC LIMIT 10;

SELECT last_name, COUNT(last_name) 
	FROM actors 
	GROUP BY last_name 
	ORDER BY COUNT(last_name) 
	DESC LIMIT 10;

-- Prolific
EXPLAIN QUERY PLAN SELECT actor_id, COUNT(actor_id), first_name, last_name
	FROM roles
	JOIN actors ON id = actor_id
	GROUP BY actor_id
	ORDER BY COUNT(actor_id)
	DESC LIMIT 100

-- Bottom of the Barrel
	SELECT genre, COUNT(genre)
	FROM movies_genres
	GROUP BY genre
	ORDER BY COUNT(genre);

-- Braveheart
SELECT movies.id, actor_id, first_name, last_name
	FROM movies
	JOIN roles ON movies.id = movie_id
	JOIN actors on actor_id = actors.id
	WHERE name='Braveheart'
		AND year=1995
	ORDER BY last_name;

-- Leap Noir
SELECT directors.first_name, directors.last_name, movies.name, movies.year							
	FROM directors 	
	JOIN movies_directors ON movies_directors.director_id = directors.id 
	JOIN movies ON movies_directors.movie_id = movies.id
	JOIN movies_genres ON movies_genres.movie_id = movies.id
	WHERE genre="Film-Noir"
		AND movies.year % 4 = 0
	ORDER BY movies.name;

-- Bacon
SELECT actors.first_name, actors.last_name, movies.name
	FROM actors
	JOIN roles ON roles.actor_id = actors.id
	JOIN movies ON movies.id = roles.movie_id
	WHERE actors.first_name<>"Kevin" 
		AND actors.last_name<>"Bacon"
		AND movies.id IN
		(SELECT movies.id
			FROM movies
			JOIN movies_genres ON movies_genres.movie_id = movies.id
			JOIN roles ON roles.movie_id = movies_genres.movie_id
			JOIN actors on actors.id = roles.actor_id
			WHERE first_name="Kevin"
				AND last_name="Bacon"
				AND movies_genres.genre="Drama")
	ORDER BY movies.name DESC, actors.last_name DESC;

-- Immortal actors
SELECT actors.first_name, actors.last_name, actors.id
	FROM movies
	JOIN roles ON roles.movie_id = movies.id
	JOIN actors ON actors.id = roles.actor_id
	WHERE movies.year < 1900 
INTERSECT
SELECT actors.first_name, actors.last_name, actors.id
	FROM movies
	JOIN roles ON roles.movie_id = movies.id
	JOIN actors ON actors.id = roles.actor_id
	WHERE movies.year > 2000
ORDER BY actors.last_name DESC;

-- Busy filming
SELECT actors.first_name, actors.last_name, movies.name, movies.year, COUNT(DISTINCT roles.role) AS roll5
	FROM roles
	JOIN movies ON movies.id = roles.movie_id
	JOIN actors ON actors.id = roles.actor_id
	WHERE movies.year > 1990
	GROUP BY actors.id, movies.id
	HAVING roll5 > 4;

-- ♀
SELECT movies.year, COUNT(movies.year)
	FROM movies
	WHERE movies.id NOT IN
		(SELECT movies.id
			FROM movies
			JOIN roles ON roles.movie_id = movies.id
			JOIN actors ON actors.id = roles.actor_id	
			WHERE actors.gender = 'M'
			GROUP BY actors.gender, movies.id
				HAVING COUNT(actors.gender) > 0)
	GROUP BY movies.year
	ORDER by movies.year;

	








