
scimodule = {name: "scimodule"}

#region node_modules
require('systemd')
express = require('express')
bodyParser = require('body-parser')
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["scimodule"]?  then console.log "[scimodule]: " + arg
    return

#region internal variables
cfg = null
budget = null
strategy = null
intelligence = null

app = null
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
scimodule.initialize = () ->
    log "scimodule.initialize"
    cfg = allModules.configmodule
    budget = allModules.budgetmanagermodule
    strategy = allModules.robustarbitragestrategymodule
    intelligence = allModules.intelligencemodule

    app = express()
    app.use bodyParser.urlencoded(extended: false)
    app.use bodyParser.json()
    return

#region internal functions
onGetIdeas = (req, res) ->
    log "onGetIdeas"
    ideas = strategy.getCurrentIdeas()
    res.send(ideas)
    return

onGetActionMemory = (req, res) ->
    log "onGetActionMemory"
    actionMemory = intelligence.getActionMemory()
    res.send(actionMemory)
    return

onGetOrderMemory = (req, res) ->
    log "onGetOrderMemory"
    orderMemory = intelligence.getOrderMemory()
    res.send(orderMemory)
    return

onGetIdeaMemory = (req, res) ->
    log "onGetIdeaMemory"
    ideaMemory = intelligence.getIdeaMemory()
    res.send(ideaMemory)
    return

onGetBudgets = (req, res) ->
    log "onGetBudgets"
    budgets = budget.getAllBudgets()
    res.send(budgets)
    return

onGetActivityLog = (req, res) ->
    log "onGetActivityLog"
    activityLog = budget.getActivityLog()
    res.send({activityLog})
    return

#################################################################
attachSCIFunctions = ->
    log "attachSCIFunctions"
    app.post "/getActivityLog", onGetActivityLog
    app.post "/getBudgets", onGetBudgets
    app.post "/getIdeas", onGetIdeas
    app.post "/getActionMemory", onGetActionMemory
    app.post "/getOrderMemory", onGetOrderMemory
    app.post "/getIdeaMemory", onGetIdeaMemory
    return

listenForRequests = ->
    log "listenForRequests"
    if process.env.SOCKETMODE
        app.listen "systemd"
        log "listening on systemd"
    else
        port = process.env.PORT || cfg.defaultPort
        app.listen port
        log "listening on port: " + port
    return
#endregion

#region exposed functions
scimodule.prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    attachSCIFunctions()
    listenForRequests()
    return

#endregion exposed functions

export default scimodule