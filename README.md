# Grand Slam Point-by-Point Data, 2011-present

This repo contains point-by-point data for most[1] main-draw singles Grand Slam matches since 2011. It was scraped from the four Grand Slam websites shortly after each event.

There are two files for each tournament. "-matches.csv" contain metadata for all the singles matches included from the tournament, and '-points.csv' contains all the available data for each point. Where doubles data is available, men's and women's doubles are in files with suffixes "-matches-doubles.csv" and "-points-doubles.csv." Where mixed doubles data is available, it is in files with suffixes "-matches-mixed.csv" and "-points-mixed.csv."

Unfortunately, much of the most useful data isn't available for every tournament, such as serve speed, first/second serve indicators, and rally length. In some cases, very similar data (such as rally length) does not appear in the same column for every event. On the bright side, there's more data now than a few years ago, with additions such as distance run, serve depth, and return depth.

For even more detailed data, including non-slam matches but not including *all* slam matches, see my Match Charting Project[2].

I'll try to keep this updated after each tournament, but I can't make any promises as to punctuality.

# 'Missing' events

Most of the data in this repo was published by the grand slams as part of IBM's "Slamtracker" feature. Starting in 2018, the Australian Open and French Open no longer worked with IBM. They partnered with Infosys, which now offers a similar "MatchBeats" feature on the AO and FO websites. Much of the data is similar -- serve speeds, 1st/2nd serve indicators, rally lengths, and ace/double fault/winner/unforced error indicators -- though some of IBM's newer features, such as distance run, are not included.

I've transformed the published data from the 2018-present AO and FO into a format similar to the "Slamtracker" data from other events. Using data from both Slamtracker and MatchBeats events will require attention to which attributes are available for which slams. (As noted above, this is also true for Slamtracker alone, which was not consistent from year to year.) However, I've tried to make this as seamless as possible.

From the 2018-19 AO and FO, there are many matches (especially doubles) in which serve speed and rally length were not recorded. In the original source data, serve speed is always noted as 0, and rally length is 3 or 0. Use of data from those matches would require careful attention to those limitations.

# Doubles

I've added 2018-19 French Open and 2018-21 Australian Open men's, women's, and mixed doubles, with the same limitations as the singles data from those events, as mentioned above. To accommodate doubles, I've added several columns to the 'matches' files for doubles events, such that 'partner1' is the partner of 'player1', and so on. I don't have equivalent doubles data for most of the other slams with singles data included here, but I do have a bit, and I hope to clean that up and include it in the future.

# License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Dataset" property="dct:title" rel="dct:type">Tennis databases, files, and algorithms</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.tennisabstract.com/" property="cc:attributionName" rel="cc:attributionURL">Jeff Sackmann / Tennis Abstract</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/JeffSackmann" rel="dct:source">https://github.com/JeffSackmann</a>.

In other words: Attribution is required. Non-commercial use only.

---

[1] In general, this data is available for matches on courts with the Hawkeye system installed. The vast majority of missing matches are first-rounders. Many of the more recent events included all matches.

[2] Homepage: http://www.tennisabstract.com/charting/meta.html
Repo: https://github.com/JeffSackmann/tennis_MatchChartingProject
