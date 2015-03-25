begin;

drop table if exists ncaa_sr.beta_results;

create table ncaa_sr.beta_results (
	game_id		      integer,
	year		      integer,
	game_date	      date,
	type		      text,
	team_name	      text,
	team_id		      text,
	opponent_name	      text,
	opponent_id	      text,
	location_id	      text,
	field		      text,
	team_score	      integer,
	opponent_score	      integer,
	game_length	      text
);

insert into ncaa_sr.beta_results
(game_id,year,
 game_date,type,
 team_name,team_id,
 opponent_name,opponent_id,
 location_id,field,
 team_score,opponent_score,game_length)
(
select
game_id,
year,
game_date,
type,
school_name,
school_id,
opponent,
opponent_id,
location as location_id,
(case when location is null then 'offense_home'
      when location='@' then 'defense_home'
      else 'neutral' end) as field,
team_score,
opponent_score,
ot as game_length
from ncaa_sr.games g
where
    g.team_score is not NULL
and g.opponent_score is not NULL
and g.team_score >= 0
and g.opponent_score >= 0
and g.school_id is not NULL
and g.opponent_id is not NULL

and ((g.location is null) or
     (g.location='N' and g.school_id < g.opponent_id))
);

insert into ncaa_sr.beta_results
(game_id,year,
 game_date,type,
 team_name,team_id,
 opponent_name,opponent_id,
 location_id,field,
 team_score,opponent_score,game_length)
(
select
game_id,
year,
game_date,
type,
opponent,
opponent_id,
school_name,
school_id,
location as location_id,
(case when location is null then 'defense_home'
      when location='@' then 'offense_home'
      else 'neutral' end) as field,
opponent_score,
team_score,
ot as game_length
from ncaa_sr.games g
where
    g.team_score is not NULL
and g.opponent_score is not NULL
and g.team_score >= 0
and g.opponent_score >= 0
and g.school_id is not NULL
and g.opponent_id is not NULL

and ((g.location is null) or
     (g.location='N' and g.school_id < g.opponent_id))
);

update ncaa_sr.beta_results
set game_length='1OT'
where game_length='OT';

update ncaa_sr.beta_results
set game_length='0OT'
where game_length is null;

commit;
