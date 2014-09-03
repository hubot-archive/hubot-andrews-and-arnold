# Description:
#   Show Andrews & Arnold ISP Quota
#
# Configuration:
#   HUBOT_AA_NET_API_USER - set the AA.net API Username
#   HUBOT_AA_NET_API_PASS - set the AA.net API Password
# Commands:
#   hubot: isp quota - Show how much of the Quota has been used
#
# Author:
#  John Hamelink <john@farmer.io>


module.exports = (robot) ->

  getAuth = () ->
    user = process.env.HUBOT_AA_NET_API_USER
    pass = process.env.HUBOT_AA_NET_API_PASS
    'Basic ' + new Buffer(user + ":" + pass).toString('base64');

  getQuota = (json) ->
    total = parseInt(json['login'][0]['broadband'][0]['quota_monthly'], 10)
    left  = parseInt(json['login'][0]['broadband'][0]['quota_left'], 10)
    leftGB  = (left / 1000000000).toFixed(2)
    totalGB = (total / 1000000000).toFixed(2)
    percentage = (left/total * 100).toFixed(2)
    "#{leftGB}GB of #{totalGB}GB (#{percentage}% left)"

  robot.respond /isp quota/i, (msg) ->
    req = "https://chaos.aa.net.uk/info?JSON=1"
    robot.http(req).header('authorization', getAuth()).get() (err, res, body) ->
      msg.send "Error: #{err}" if err
      json = JSON.parse body
      msg.send "Quota: #{getQuota(json)}"
