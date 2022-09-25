
# https://github.com/thetvdb/tvdb-v4-python
from venv import create
import tvdb_v4_official
import json
import os

API_KEY_FILE="/Users/shashidhar/.config/thetvdb/api_key.json"

cred = json.load(open(API_KEY_FILE))

API_KEY = open(API_KEY_FILE).read()

print(API_KEY[:-1])
tvdb = tvdb_v4_official.TVDB(cred["api_key"], pin=cred["pin"])

print(dir(tvdb))


def create_series_metadata():
    total_num_series = 0
    series_list = [ ]
    pg_num = 0
    while(True): 

        curr_series_list = tvdb.get_all_series(pg_num)
        trunc_list = list(filter(lambda s: s['score'] > 1000000, curr_series_list))
        total_num_series += len(trunc_list)
        print(pg_num, total_num_series)
        pg_num += 1
        series_list += trunc_list
        if len(curr_series_list) == 0:
            break

    with open("all_series.json", "w") as fd:
        json.dump(series_list, fd)


def create_all_movies():
    total_num_movies = 0
    movies_list = [ ]
    pg_num = 0
    while(True): 

        curr_movies_list = tvdb.get_all_movies(pg_num)
        trunc_list = list(filter(lambda s: s['score'] > 100000, curr_movies_list))
        total_num_movies += len(trunc_list)
        print(pg_num, total_num_movies)
        pg_num += 1
        movies_list += trunc_list
        if pg_num > 300:
            break
        if len(curr_movies_list) == 0:
            break

    with open("movies/all_movies.json", "w") as fd:
        json.dump(movies_list, fd)

def get_series_extended_and_all_episodes(series_id):
    if os.path.exists(f"{series_id}.json"):
        return
    series_extended = tvdb.get_series_extended(series_id)
    all_episodes = tvdb.get_series_episodes(series_id)["episodes"]
    episodes_extended = []
    for episode in all_episodes:
        episodes_extended.append(tvdb.get_episode_extended(episode["id"]))
    series_object = dict(series_extended=series_extended, episodes_extended=episodes_extended)
    with open(f"{series_id}.json", "w") as fd:
        json.dump(series_object, fd)


def get_movies_extended(movie_id):
    out_filename = f"movies/{movie_id}.json"
    if os.path.exists(out_filename):
        return
    movie_extended = tvdb.get_movie_extended(movie_id)
    with open(out_filename, "w") as fd:
        json.dump(movie_extended, fd)

def get_series_extended_and_all_episodes(series_id):
    if os.path.exists(f"{series_id}.json"):
        return
    series_extended = tvdb.get_series_extended(series_id)
    all_episodes = tvdb.get_series_episodes(series_id)["episodes"]
    episodes_extended = []
    for episode in all_episodes:
        episodes_extended.append(tvdb.get_episode_extended(episode["id"]))
    series_object = dict(series_extended=series_extended, episodes_extended=episodes_extended)
    with open(f"{series_id}.json", "w") as fd:
        json.dump(series_object, fd)


def dump_all_series():
    with open("all_series.json", "r") as fd:
        all_series = json.load(fd)

    for series in all_series:
        print(series['id'])
        get_series_extended_and_all_episodes(series['id'])


def dump_all_movies():
    with open("movies/all_movies.json", "r") as fd:
        all_movies = json.load(fd)

    for movie in all_movies:
        print(movie['id'])
        get_movies_extended(movie['id'])


if __name__ == "__main__":
    #create_series_metadata()
    # dump_all_series()
    # create_all_movies()
    dump_all_movies()



