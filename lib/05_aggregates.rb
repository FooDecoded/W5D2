# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def example_sum
  execute(<<-SQL)
    SELECT
      SUM(population)
    FROM
      countries
  SQL
end

def continents
  # List all the continents - just once each.
  execute(<<-SQL)
  SELECT DISTINCT continent 
  FROM countries 
  SQL
end

def africa_gdp
  # Give the total GDP of Africa.
  execute(<<-SQL)
  SELECT sum(gdp) as AFRICA_DGP
  from countries where continent = 'Africa'
  SQL
end

def area_count
  # How many countries have an area of more than 1,000,000?
  execute(<<-SQL)
  SELECT COUNT(*) as count_area
  from countries where area > 1000000
  SQL
end

def group_population
  # What is the total population of ('France','Germany','Spain')?
  execute(<<-SQL)
  select sum(population) as pop
  from countries where name in ('France','Germany','Spain')
  SQL
end

def country_counts
  # For each continent show the continent and number of countries.
  execute(<<-SQL)
  SELECT continent, count(*) from countries 
  GROUP BY continent
  SQL
end

def populous_country_counts
  # For each continent show the continent and number of countries with
  # populations of at least 10 million.
  execute(<<-SQL)
  SELECT continent, count(*) from countries 
  WHERE population >= 10000000
  GROUP BY continent 
  SQL
end

def populous_continents
  # List the continents that have a total population of at least 100 million.
  execute(<<-SQL)
  SELECT continent from countries 
  group by continent having sum(population) >= 100000000
  SQL
end
