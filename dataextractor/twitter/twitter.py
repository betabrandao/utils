#!/bin/env python

import pandas as pd
from twitter.scraper import Scraper
from twitter.util import find_key

## sign-in with credentials cookies
cookies={
        "ct0": "0c8413c264e17f57f1b6b05e997eab028069205d3ac19b6bc2db8db9319a1ba8d3c5bdb459f10b8dc557b562dc81e7bf1d89a26a0c379eed37d7a343a5468a44931c99a3c20219929be7f3f20425b380",
        "auth_token": "a807e52d10ace05097aac7f1705d030e3d8840e7"
        }

def parse_tweets(data: list | dict) -> pd.DataFrame:
    """
    Parse small subset of relevant features into a DataFrame.
    Note: structure of GraphQL response is not consistent, this example may not work in all cases.

    @param data: tweets (raw GraphQL response data)
    @return: DataFrame of tweets
    """
    df = (
        pd.json_normalize((
            x.get('result', {}).get('tweet', {}).get('legacy') for x in find_key(data, 'tweet_results')),
            max_level=1
        )
        #.assign(created_at=lambda x: pd.to_datetime(x['created_at'], format="%a %b %d %H:%M:%S %z %Y"))
        #.sort_values('created_at', ascending=False)
        .reset_index(drop=True)
    )
    numeric = [
        'user_id_str',
        'id_str',
        'favorite_count',
        'quote_count',
        'reply_count',
        'retweet_count',
    ]
    df[numeric] = df[numeric].apply(pd.to_numeric, errors='coerce')
    df = df[[
        'id_str',
        'user_id_str',
        #'created_at',
        'full_text',
        'favorite_count',
        'quote_count',
        'reply_count',
        'retweet_count',
        'lang',
    ]]
    return df

if __name__ == "__main__":
    ## or, resume session using cookies
    scraper = Scraper(cookies=cookies)

    ## or, resume session using cookies (JSON file)
    # scraper = Scraper(cookies='twitter.cookies')

    ## or, initialize guest session (limited endpoints)
    # from twitter.util import init_session
    # scraper = Scraper(session=init_session())

    tweets = scraper.tweets_by_ids([1750581446270431512])

    df = parse_tweets(tweets)

    # df.to_parquet('teets.parquet', engine='pyarrow')
    df.to_csv('tweets.csv')
