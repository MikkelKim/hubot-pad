# Description
#   A hubot script that retrieves pad info
#
# Commands:
#   hubot pad me <query>
#
# Author:
#   mikkel

module.exports = (robot) ->

  monsterDict = require('./monster')
  leaderSkillDict = require('./leaderSkill')
  activeSkillDict = require('./activeSkill')

  getMonsterInfo = (id) ->
    for monster in monsterDict
      return monster if parseInt(monster['id'], 10) == id

  getLeaderSkillInfo = (id, leaderSkill) ->
    for ls in leaderSkillDict
      return ls if ls['name'] == leaderSkill

  getActiveSkillInfo = (id, activeSkill) ->
    for as in activeSkillDict
      return as if as['name'] == activeSkill

  getFormattedInfo = (id) ->
    text = ""
    monsterInfo = getMonsterInfo(id)

    leaderSkill = monsterInfo['leader_skill']
    leaderSkillInfo = getLeaderSkillInfo(id, leaderSkill)

    activeSkill = monsterInfo['active_skill']
    activeSkillInfo = getActiveSkillInfo(id, activeSkill)

    text += monsterInfo['name'] + "\n"
    text += "Rarity: " + monsterInfo['rarity'] + "\tMax ATK: " + monsterInfo['atk_max'] + "\tMax HP: " + monsterInfo['hp_max'] + "\tMax RCV: " + monsterInfo['rcv_max'] + "\n"
    text += "Leader Skill: " + leaderSkillInfo['effect'] + "\n"
    text += "Active Skill: " + activeSkillInfo['effect'] + "\n"
    text += "Max CD: " + activeSkillInfo['max_cooldown'] + "\tMin CD: " + activeSkillInfo['min_cooldown'] + "\n\n"
    return text

  robot.respond /(pad)( me)? (.*)/i, (msg) ->
    msg
      .http("https://www.googleapis.com/customsearch/v1")
      .query
        key: process.env.PADX_GOOGLE_SEARCH_KEY
        cx: process.env.PADX_GOOGLE_SEARCH_CX
        fields: "items(link)"
        num: 3
        q: msg.match[3]
      .get() (err, res, body) ->
        resp = "\n";
        searchResults = JSON.parse body     
        searchResults.items.forEach (item) ->
          id = parseInt(item.link.split("=").pop(), 10)
          resp += getFormattedInfo(id)
        msg.send resp
