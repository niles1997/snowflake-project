from config import API_KEY
import requests
def get_movie_data(i):
    response=requests.get('https://api.themoviedb.org/3/movie/top_rated?api_key={}&&language=en-US&page={}'.format(API_KEY,i))
    Jsondata=response.json()['results']
    return Jsondata
def lamdba_handler(event,context):
    results=get_movie_data(1)
    print(results)

