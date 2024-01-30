#!/bin/env python

import pandas as pd
from twitter.scraper import Scraper
from twitter.util import find_key

## sign-in with credentials cookies
cookies={
        "ct0": "8462ce9af68b2f6ecc16e9c2f24d7e7729780e71420c1efb43068827a2cef8ad6e66fe3ea0303797a70c4ef070cf95b8664c7cc71d96aa3b4870772c7d54eb8e5eb3c201f95dbbb3daf4e658a0499d68",
        "auth_token": "72ad52ca4918aec57041a041437aff7493a9f0cd"
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

    tweets = scraper.tweets_by_ids([
        1751914735522472324, 
        1751776901343977599, 
        1749859822084805011, 
        1751373408158331029, 
        1751283180420608042,
        1750981019270852648,
        1750543685002162478,
        1750564354162917512,
        1750581446270431512,
        1750320076337659985])

    df = parse_tweets(tweets)

    # df.to_parquet('teets.parquet', engine='pyarrow')
    df.to_csv('tweets.csv')
