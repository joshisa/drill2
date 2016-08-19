angular.module 'DrillApp'

.filter 'decPlaces', ->
  (x, dec) ->
    pow = 10 ** dec
    (Math.round x * pow) / pow

.filter 'markdown', ($sce) ->
  (str, $scope) ->
    return '' unless str && $scope.config.markdown

    parser = new commonmark.Parser()
    renderer = new commonmark.HtmlRenderer()

    ast = parser.parse str

    # fixes double newlines
    fix = (node) ->
      if node._type is 'CodeBlock'
        # fix double newlines
        str = node._literal

        # fenced code blocks have additional newlines on ends
        if node._isFenced
          str = str.substring 1, (str.length - 1)

        split = str.split '\n'
        wanted = []

        for i in [0...split.length] by 2
          wanted.push split[i]

        node._literal = wanted.join '\n'
        return

      else
        fix node._firstChild if node._firstChild
        fix node._next if node._next
        return

    fix ast
    html = renderer.render ast

    $sce.trustAsHtml html

.filter 'lines', ->
  (str) ->
    if str then str.split /\s*(?:\r?\n)(?:\r?\n\s)*/ else []

.filter 'doubleNewlines', ->
  (str) ->
    if str then str.replace(/\n+/g, '\n\n') else ''

.filter 'minutes', ->
  (secs) ->
    return '' unless secs
    secs = parseInt secs

    mins = Math.floor (secs / 60)
    secs = (secs % 60).toString()
    while secs.length < 2
      secs = '0' + secs

    "#{mins}:#{secs}"

.filter 'minsSecs', ->
  (secs) ->
    mins = Math.floor (secs / 60)
    mstr = if mins > 0 then mins + 'm ' else ''
    mstr + (secs % 60) + 's'

.filter 'scoreFormat', (decPlacesFilter, minsSecsFilter) ->
  (score, limitedTime, timeLimit) ->
    score_ = decPlacesFilter score.score, 2
    total = decPlacesFilter score.total, 2
    str = "#{score_} / #{total} pts"

    if limitedTime
      str += ', ' + minsSecsFilter(timeLimit - score.timeLeft)

    str

.filter 'no', ->
  (x, capitalized) ->
    x ? if capitalized then 'No' else 'no'

.filter 'averageTime', ->
  (questions, timeLimit) ->
    count = 0
    total = 0
    for question in questions
      count += question.scoreLog.length
      for log in question.scoreLog
        total += timeLimit - log.timeLeft

    Math.round (total / count)

.filter 'shuffle', ->
  (input) ->
    input_copy = input.slice(0)
    unsorted_count = input_copy.length

    while unsorted_count
      next_index = Math.floor(Math.random() * unsorted_count)
      unsorted_count--

      swap_temp = input_copy[next_index]
      input_copy[unsorted_count] = input_copy[next_index]
      input_copy[next_index] = swap_temp

    input_copy

.filter 'percentageOf', ->
  (fraction, total) ->
    if total != 0
      Math.round(fraction * 100 / total) + '%'
    else '0%'