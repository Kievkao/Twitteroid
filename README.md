# Twitteroid
- Video processing trick in the application:
Regarding to official Twitter API documentation, media entity in the Tweet object has a field with media type value. And for now only "Photo" type is supported.
So it's only possible to determine whether attached link is a photo link or "not a photo".
Considering this feature we are able to determine video links by analyzing the domain of the link.
For example we can set a list of video hostings which we plan to support and filter all links through this list.
This test application provides support of Youtube related links.

- Please refer to official documentation:
https://dev.twitter.com/overview/api/entities-in-twitter-objects#media
See "The media entity" section, "type" field description.
