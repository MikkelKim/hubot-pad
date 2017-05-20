# Description
#   A hubot script that retrieves pad info
#
# Commands:
#   hubot pad me <query>
#
# Author:
#   mikkel

module.exports = (robot) ->

  robot.respond /(pad)( me)? (.*)/i, (msg) ->
    msg
      .http("https://www.googleapis.com/customsearch/v1")
      .query
        key: process.env.PADX_GOOGLE_SEARCH_KEY
        cx: process.env.PADX_GOOGLE_SEARCH_CX
        fields: "items(title,link)"
        num: 3
        q: msg.match[3]
      .get() (err, res, body) ->
        resp = "\n";
        results = JSON.parse body
        index = 1
        results.items.forEach (item) ->       
          resp += index.toString() + ". name:  " + item.title + "\n   link:  " + item.link + "\n"
          ++index
        msg.send resp
